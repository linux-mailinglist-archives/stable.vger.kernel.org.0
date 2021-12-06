Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D2469E73
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359062AbhLFPi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379212AbhLFPgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772CAC08EAD6;
        Mon,  6 Dec 2021 07:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D402BB8111E;
        Mon,  6 Dec 2021 15:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11956C341C1;
        Mon,  6 Dec 2021 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804183;
        bh=YB9GqF06IpmSyCG7Faw9WpOdPVo8RXr05d3IdS4a6qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i68TXC/ythu7lVolHOTsSJIkAELRXW9f6KJ6zbTlq05dzoV9lk0SdNkZJh+DL2rzE
         ePPPUXOshZkqMEyPXz8kV6Zt7LEY618gy4Koe9xEjIQiU6W6b8+a4vnK22MP2dPPYE
         BwuT8GSMw+aaKjEasvgBQL4bJLMHuegdiRXLGedA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>, Exuvo <exuvo@exuvo.se>
Subject: [PATCH 5.15 056/207] rt2x00: do not mark device gone on EPROTO errors during start
Date:   Mon,  6 Dec 2021 15:55:10 +0100
Message-Id: <20211206145612.178542847@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit ed53ae75693096f1c10b4561edd31a07b631bd72 upstream.

As reported by Exuvo is possible that we have lot's of EPROTO errors
during device start i.e. firmware load. But after that device works
correctly. Hence marking device gone by few EPROTO errors done by
commit e383c70474db ("rt2x00: check number of EPROTO errors") caused
regression - Exuvo device stop working after kernel update. To fix
disable the check during device start.

Link: https://lore.kernel.org/linux-wireless/bff7d309-a816-6a75-51b6-5928ef4f7a8c@exuvo.se/
Reported-and-tested-by: Exuvo <exuvo@exuvo.se>
Fixes: e383c70474db ("rt2x00: check number of EPROTO errors")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211111141003.GA134627@wp.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -25,6 +25,9 @@ static bool rt2x00usb_check_usb_error(st
 	if (status == -ENODEV || status == -ENOENT)
 		return true;
 
+	if (!test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
+		return false;
+
 	if (status == -EPROTO || status == -ETIMEDOUT)
 		rt2x00dev->num_proto_errs++;
 	else


