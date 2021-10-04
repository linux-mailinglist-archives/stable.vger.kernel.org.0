Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85506420EC0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhJDN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237106AbhJDN0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD18F61C32;
        Mon,  4 Oct 2021 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353088;
        bh=139i+vU/Vrd6p109Ed/zuAP4DoRqWlAoxEoeuH58J94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDdRax+NFFg+Wfr9KM0rbMiDEXlnT4rMKMrii7x/VOr7O2xSyzvv9EIgAREAEnZ4l
         wiCEN8baY7CAj5J+tEBb+jJtQlmjaKN1aYXa3mkR5YPNQANtlCtcBhXbPkvptte1lp
         Y8Xmqk6F9FMqbwxuLejNSK7XXZ1jm7yhs0Oy6Vlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 84/93] usb: hso: remove the bailout parameter
Date:   Mon,  4 Oct 2021 14:53:22 +0200
Message-Id: <20211004125037.383513731@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit dcb713d53e2eadf42b878c12a471e74dc6ed3145 upstream.

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Backport this cleanup patch to 5.10 and 5.14 in order to keep the
codebase consistent with the 4.14/4.19/5.4 patchseries]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2354,7 +2354,7 @@ static int remove_net_device(struct hso_
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2377,7 +2377,7 @@ static void hso_free_net_device(struct h
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3137,7 +3137,7 @@ static void hso_free_interface(struct us
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }


