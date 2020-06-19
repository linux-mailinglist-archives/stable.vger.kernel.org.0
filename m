Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A52016E0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbgFSOpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388742AbgFSOpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF34E217D9;
        Fri, 19 Jun 2020 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577943;
        bh=NWMLcpyikfEyP3vhtWUk2KoId6XXFoE9zxGdE35jo0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEy9Zj3OGxmsPVwGFo1JZXuH6hJTmlM0/XEYRlu8VEUjfKmtNqBdOEkWBkCB7jrey
         g4RKnPB+HH2wypXdE2fkfR3oj3RVkSHZs7bRwEfAX5IzrQxPjabrglBZ4IyQ/v+SfE
         vn4A0saJUUzHtWK9dyzSMradtGnx9BYxq3ktZGhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E4=BA=BF=E4=B8=80?= <teroincn@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.14 022/190] efi/efivars: Add missing kobject_put() in sysfs entry creation error path
Date:   Fri, 19 Jun 2020 16:31:07 +0200
Message-Id: <20200619141634.589921454@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit d8bd8c6e2cfab8b78b537715255be8d7557791c0 upstream.

The documentation provided by kobject_init_and_add() clearly spells out
the need to call kobject_put() on the kobject if an error is returned.
Add this missing call to the error path.

Cc: <stable@vger.kernel.org>
Reported-by: 亿一 <teroincn@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efivars.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -586,8 +586,10 @@ efivar_create_sysfs_entry(struct efivar_
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


