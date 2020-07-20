Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0592268A1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbgGTQIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387426AbgGTQIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97B422065E;
        Mon, 20 Jul 2020 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261323;
        bh=PXoU2bDC76S87YcobBWMvvKjcfEsrThYdScmFKbPL8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W10IIMOwZ4j/Rj/lBhlbrtdWX0Xcg5TYy/V7vRrTxrAVb+RbgzSiCGaTlUW32MfCC
         TW4rJPRYAZhrWR+VvsWiJfJGwTyhROvSA7SzTcd7cJeRboOATo+6l3HKBUCdTZjWtR
         gTnSZGNZ0VxxudH1vsVkLECqXayDFKQxE498PNac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 044/244] dt-bindings: fix error in make clean after make dt_binding_check
Date:   Mon, 20 Jul 2020 17:35:15 +0200
Message-Id: <20200720152827.954271793@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit fa714cf58c7c09a454ff9fda2ee8318591128eb6 ]

We are having more and more schema files.

Commit 8b6b80218b01 ("dt-bindings: Fix command line length limit
calling dt-mk-schema") fixed the 'Argument list too long' error of
the schema checks, but the same error happens while cleaning too.

'make clean' after 'make dt_binding_check' fails as follows:

  $ make dt_binding_check
    [ snip ]
  $ make clean
  make[2]: execvp: /bin/sh: Argument list too long
  make[2]: *** [scripts/Makefile.clean:52: __clean] Error 127
  make[1]: *** [scripts/Makefile.clean:66: Documentation/devicetree/bindings] Error 2
  make: *** [Makefile:1763: _clean_Documentation] Error 2

'make dt_binding_check' generates so many .example.dts, .dt.yaml files,
which are passed to the 'rm' command when you run 'make clean'.

I added a small hack to use the 'find' command to clean up most of the
build artifacts before they are processed by scripts/Makefile.clean

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20200625170434.635114-2-masahiroy@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/Makefile b/Documentation/devicetree/bindings/Makefile
index 7782d99850823..b03d58c6b072f 100644
--- a/Documentation/devicetree/bindings/Makefile
+++ b/Documentation/devicetree/bindings/Makefile
@@ -45,3 +45,8 @@ $(obj)/processed-schema.yaml: $(DT_SCHEMA_FILES) FORCE
 	$(call if_changed,mk_schema)
 
 extra-y += processed-schema.yaml
+
+# Hack: avoid 'Argument list too long' error for 'make clean'. Remove most of
+# build artifacts here before they are processed by scripts/Makefile.clean
+clean-files = $(shell find $(obj) \( -name '*.example.dts' -o \
+			-name '*.example.dt.yaml' \) -delete 2>/dev/null)
-- 
2.25.1



