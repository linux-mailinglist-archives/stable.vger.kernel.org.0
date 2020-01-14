Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1D613A6B8
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgANKNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731313AbgANKNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:13:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD8DF20678;
        Tue, 14 Jan 2020 10:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996789;
        bh=wYWAKcoEklkSguo63Jr9BfCMLlMEPZRkyui7sWKakPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki4jYkRmiy+glvtSTRH8tmurVefvq5CApiMv0kYqUBCgUjHcYEaslir7N78BOfs6j
         ssk//T8pzdxMV6R/q5EYxU4XWyEAcjq/7qWzl7gRWwUZyaUgNeJbcNGgDQYk/b67j6
         h0TTHcThdkCoQAJN2Hh47QwLjj9EM0c6s6extN6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 25/28] rtl8xxxu: prevent leaking urb
Date:   Tue, 14 Jan 2020 11:02:27 +0100
Message-Id: <20200114094344.552035533@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit a2cdd07488e666aa93a49a3fc9c9b1299e27ef3c upstream.

In rtl8xxxu_submit_int_urb if usb_submit_urb fails the allocated urb
should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5135,6 +5135,7 @@ static int rtl8xxxu_submit_int_urb(struc
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
 		usb_unanchor_urb(urb);
+		usb_free_urb(urb);
 		goto error;
 	}
 


