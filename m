Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1A2D65E4
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390459AbgLJObF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390454AbgLJOax (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:53 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.9 44/45] Input: i8042 - fix error return code in i8042_setup_aux()
Date:   Thu, 10 Dec 2020 15:26:58 +0100
Message-Id: <20201210142604.507748588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

commit 855b69857830f8d918d715014f05e59a3f7491a0 upstream.

Fix to return a negative error code from the error handling case
instead of 0 in function i8042_setup_aux(), as done elsewhere in this
function.

Fixes: f81134163fc7 ("Input: i8042 - use platform_driver_probe")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201123133420.4071187-1-luomeng12@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1456,7 +1456,8 @@ static int __init i8042_setup_aux(void)
 	if (error)
 		goto err_free_ports;
 
-	if (aux_enable())
+	error = aux_enable();
+	if (error)
 		goto err_free_irq;
 
 	i8042_aux_irq_registered = true;


