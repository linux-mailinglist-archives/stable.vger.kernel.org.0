Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BE712F154
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgABW7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgABWNz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567EF22525;
        Thu,  2 Jan 2020 22:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003234;
        bh=6AB7D4bAghPrP0v8HFm25suaOjxnmCLappmUhVWx6eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QydQLhU7HH+AIdQvYeWfaY9FvDFP3REKSiW4++pVEVxxf3l2VX6ekEGfSqRWQ0GBE
         ny0OCN8/Cr4GU/gd272qV0Fa8mfnNmm6jYmQay2crTVmPXLS+9ZB8OgswGbfl33hMJ
         NGJEorhzRIJK53vei3zVobFNHOt1gpCNIFQOXEZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/191] dt-bindings: Improve validation build error handling
Date:   Thu,  2 Jan 2020 23:05:58 +0100
Message-Id: <20200102215838.066878098@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 93512dad334deb444619505f1fbb761156f7471b ]

Schema errors can cause make to exit before useful information is
printed. This leaves developers wondering what's wrong. It can be
overcome passing '-k' to make, but that's not an obvious solution.
There's 2 scenarios where this happens.

When using DT_SCHEMA_FILES to validate with a single schema, any error
in the schema results in processed-schema.yaml being empty causing a
make error. The result is the specific errors in the schema are never
shown because processed-schema.yaml is the first target built. Simply
making processed-schema.yaml last in extra-y ensures the full schema
validation with detailed error messages happen first.

The 2nd problem is while schema errors are ignored for
processed-schema.yaml, full validation of the schema still runs in
parallel and any schema validation errors will still stop the build when
running validation of dts files. The fix is to not add the schema
examples to extra-y in this case. This means 'dtbs_check' is no longer a
superset of 'dt_binding_check'. Update the documentation to make this
clear.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Jeffrey Hugo <jhugo@codeaurora.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/Makefile  | 5 ++++-
 Documentation/devicetree/writing-schema.rst | 6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/Makefile b/Documentation/devicetree/bindings/Makefile
index 5138a2f6232a..646cb3525373 100644
--- a/Documentation/devicetree/bindings/Makefile
+++ b/Documentation/devicetree/bindings/Makefile
@@ -12,7 +12,6 @@ $(obj)/%.example.dts: $(src)/%.yaml FORCE
 	$(call if_changed,chk_binding)
 
 DT_TMP_SCHEMA := processed-schema.yaml
-extra-y += $(DT_TMP_SCHEMA)
 
 quiet_cmd_mk_schema = SCHEMA  $@
       cmd_mk_schema = $(DT_MK_SCHEMA) $(DT_MK_SCHEMA_FLAGS) -o $@ $(real-prereqs)
@@ -26,8 +25,12 @@ DT_DOCS = $(shell \
 
 DT_SCHEMA_FILES ?= $(addprefix $(src)/,$(DT_DOCS))
 
+ifeq ($(CHECK_DTBS),)
 extra-y += $(patsubst $(src)/%.yaml,%.example.dts, $(DT_SCHEMA_FILES))
 extra-y += $(patsubst $(src)/%.yaml,%.example.dt.yaml, $(DT_SCHEMA_FILES))
+endif
 
 $(obj)/$(DT_TMP_SCHEMA): $(DT_SCHEMA_FILES) FORCE
 	$(call if_changed,mk_schema)
+
+extra-y += $(DT_TMP_SCHEMA)
diff --git a/Documentation/devicetree/writing-schema.rst b/Documentation/devicetree/writing-schema.rst
index f4a638072262..83e04e5c342d 100644
--- a/Documentation/devicetree/writing-schema.rst
+++ b/Documentation/devicetree/writing-schema.rst
@@ -130,11 +130,13 @@ binding schema. All of the DT binding documents can be validated using the
 
     make dt_binding_check
 
-In order to perform validation of DT source files, use the `dtbs_check` target::
+In order to perform validation of DT source files, use the ``dtbs_check`` target::
 
     make dtbs_check
 
-This will first run the `dt_binding_check` which generates the processed schema.
+Note that ``dtbs_check`` will skip any binding schema files with errors. It is
+necessary to use ``dt_binding_check`` to get all the validation errors in the
+binding schema files.
 
 It is also possible to run checks with a single schema file by setting the
 ``DT_SCHEMA_FILES`` variable to a specific schema file.
-- 
2.20.1



