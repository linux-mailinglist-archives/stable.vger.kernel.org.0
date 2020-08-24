Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C4424FA24
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgHXJxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbgHXIiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:38:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E3520FC3;
        Mon, 24 Aug 2020 08:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258290;
        bh=5cbQV9c2lHZGlqdrGa8MUGaqrhRQfarfY4yneXqdzGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVBMMQbQA9mbuFlL8L2rGKq+GCOD8VQrnUaSEhJfe8auPVlQLLpjW90Hkftvy3+6r
         uhRu7QO+MnhXMytckTeOJQsQiLqujToPrcdAEonV4Ns0IiQ53o06p52rL4J5i4wYXy
         g8TK2isHY4uuGHWCA/9DaPkpc/MnMHeRsl/ocIhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Heng <liheng40@huawei.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.8 144/148] efi: add missed destroy_workqueue when efisubsys_init fails
Date:   Mon, 24 Aug 2020 10:30:42 +0200
Message-Id: <20200824082420.921660253@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Heng <liheng40@huawei.com>

commit 98086df8b70c06234a8f4290c46064e44dafa0ed upstream.

destroy_workqueue() should be called to destroy efi_rts_wq
when efisubsys_init() init resources fails.

Cc: <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
Link: https://lore.kernel.org/r/1595229738-10087-1-git-send-email-liheng40@huawei.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -381,6 +381,7 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
+		destroy_workqueue(efi_rts_wq);
 		return -ENOMEM;
 	}
 
@@ -424,6 +425,7 @@ err_unregister:
 		generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
+	destroy_workqueue(efi_rts_wq);
 	return error;
 }
 


