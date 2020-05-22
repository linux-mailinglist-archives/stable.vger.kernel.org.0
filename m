Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9481DED14
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgEVQT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 12:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgEVQT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 12:19:26 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9126220663;
        Fri, 22 May 2020 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590164365;
        bh=+QhC+C5n1cmuJNLlPAEMB7lBS29oU4DmZXpEwoEdz5o=;
        h=From:To:Cc:Subject:Date:From;
        b=XWqEaNUgIaqcFS5lKTE+5v4Rt4/x2ZDNlO3ixDxszJIPNgkx6qxIvDf68P3lqEGzM
         4idGYKzPq286QKG6EPTryVBCGRXD8CbzskRSV4t8oBC6ZVdwDZAVAueo5Pdgr4+PZF
         HyxWY8w/24pQCh69Jb1U5mtik2QeG4EdHXZSXsEQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     teroincn@gmail.com, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] efi/efivars: Add missing kobject_put() in sysfs entry creation error path
Date:   Fri, 22 May 2020 18:19:20 +0200
Message-Id: <20200522161920.367-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The documentation provided by kobject_init_and_add() clearly spells out
the need to call kobject_put() on the kobject if an error is returned.
Add this missing call to the error path.

Cc: <stable@vger.kernel.org>
Reported-by: 亿一 <teroincn@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efivars.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 78ad1ba8c987..26528a46d99e 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -522,8 +522,10 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	ret = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
 				   NULL, "%s", short_name);
 	kfree(short_name);
-	if (ret)
+	if (ret) {
+		kobject_put(&new_var->kobj);
 		return ret;
+	}
 
 	kobject_uevent(&new_var->kobj, KOBJ_ADD);
 	if (efivar_entry_add(new_var, &efivar_sysfs_list)) {
-- 
2.17.1

