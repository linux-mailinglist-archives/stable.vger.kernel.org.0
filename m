Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4942581CD9
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfHENYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbfHENYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C50720644;
        Mon,  5 Aug 2019 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011481;
        bh=AuWFkT9W+50KDlr1VVDi4qrZYNDIOBbFQEldeM0PpMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNwHLwojgd6+e3FcF+UHZFXpcKxloDMmzVC2oZAiksPw8zLkLasGeXt/tr/2YgA2M
         VngJCGnppFu0T8wpK6Yn0MAxAN1I99kXttZjI93bBjrmFfk+JPATWtQOn7qsnxIXD+
         QrYCbwQVuKtb33TTHzW6HNztKQGSrubfi7JgUl7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.2 077/131] kbuild: modpost: include .*.cmd files only when targets exist
Date:   Mon,  5 Aug 2019 15:02:44 +0200
Message-Id: <20190805124956.954506004@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 944cfe9be1fbbec73bab2f7e77fe2e8f9c72970f upstream.

If a build rule fails, the .DELETE_ON_ERROR special target removes the
target, but does nothing for the .*.cmd file, which might be corrupted.
So, .*.cmd files should be included only when the corresponding targets
exist.

Commit 392885ee82d3 ("kbuild: let fixdep directly write to .*.cmd
files") missed to fix up this file.

Fixes: 392885ee82d3 ("kbuild: let fixdep directly write to .*.cmd")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.modpost |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -142,10 +142,8 @@ FORCE:
 # optimization, we don't need to read them if the target does not
 # exist, we will rebuild anyway in that case.
 
-cmd_files := $(wildcard $(foreach f,$(sort $(targets)),$(dir $(f)).$(notdir $(f)).cmd))
+existing-targets := $(wildcard $(sort $(targets)))
 
-ifneq ($(cmd_files),)
-  include $(cmd_files)
-endif
+-include $(foreach f,$(existing-targets),$(dir $(f)).$(notdir $(f)).cmd)
 
 .PHONY: $(PHONY)


