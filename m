Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E26C576D1F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbfGZPaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbfGZPaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFE622BF5;
        Fri, 26 Jul 2019 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155046;
        bh=Zk3VFGdLnxj6L7eRlPZ1f8TcfgA404w4coNzKazCWhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8U2yBeNp5N56sDDURvLEmrQ3MblhBk5WvueoFPokPHqGX7aawDmHX/FPVGol/tPn
         NZKaKvzzZ1hPqAp//KLEblycVdzzgSl15b/HmkPno3E0ZDCU6hddvoq6bApSnRep4h
         Q1tetQq/CixYhorWATzaPxEjUxwiM8V5XNPzjn5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.1 45/62] gpiolib: of: fix a memory leak in of_gpio_flags_quirks()
Date:   Fri, 26 Jul 2019 17:24:57 +0200
Message-Id: <20190726152306.727590027@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>

commit 89fea04c85e85f21ef4937611055abce82330d48 upstream.

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a break from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put before the break.
Issue found with Coccinelle.

Cc: <stable@vger.kernel.org>
Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
[Bartosz: tweaked the commit message]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-of.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -155,6 +155,7 @@ static void of_gpio_flags_quirks(struct
 							of_node_full_name(child));
 					*flags |= OF_GPIO_ACTIVE_LOW;
 				}
+				of_node_put(child);
 				break;
 			}
 		}


