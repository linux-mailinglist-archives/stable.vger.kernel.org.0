Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB24133419
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgAGVXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgAGVBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2354321744;
        Tue,  7 Jan 2020 21:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430862;
        bh=fc4w/mC8bD6kRjx8RwBdYsE3Ln1/hmt6IeDYS8xvlXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoLdwF6MoMzTUOx0JL2twoqsgvO79W+XBDbTNDO5Moga18vG7gopFkD1nD0apgdEY
         jT46skeRuvmTVCl8YUde52KaXQaiiIOLKYFeXWEniDk71Fk+DfFQIy58j3kZd4iqgE
         sW2OWp7z8ilE7loW9xIVT6caYa+YTHrVWqPxq+cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 090/191] pstore/ram: Fix error-path memory leak in persistent_ram_new() callers
Date:   Tue,  7 Jan 2020 21:53:30 +0100
Message-Id: <20200107205337.814180441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 8df955a32a73315055e0cd187cbb1cea5820394b upstream.

For callers that allocated a label for persistent_ram_new(), if the call
fails, they must clean up the allocation.

Suggested-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Fixes: 1227daa43bce ("pstore/ram: Clarify resource reservation labels")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/20191211191353.14385-1-navid.emamdoost@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/ram.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -588,6 +588,7 @@ static int ramoops_init_przs(const char
 			dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 				name, record_size,
 				(unsigned long long)*paddr, err);
+			kfree(label);
 
 			while (i > 0) {
 				i--;
@@ -633,6 +634,7 @@ static int ramoops_init_prz(const char *
 
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
+		kfree(label);
 		return err;
 	}
 


