Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503DA469EF8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391162AbhLFPpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386648AbhLFP0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB8BC08E845;
        Mon,  6 Dec 2021 07:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B0F612C1;
        Mon,  6 Dec 2021 15:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C369C341C2;
        Mon,  6 Dec 2021 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803826;
        bh=YB9GqF06IpmSyCG7Faw9WpOdPVo8RXr05d3IdS4a6qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKsCSKPlzV5Ffprytpa7i5vSMbQG2lLH/JztbO8A4dZfCxf3I1KVjtY1v5NpUX/jV
         tpBIVcQk/XEl34+4/V4xHW0qJUjKjhV25I7K8tz0IFaBCsYfE8rlCZcd34ZgdxyvB0
         bP6cIr1aUr5x0LcFPxB4K22f1eRWnPAL7giKf8vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>, Exuvo <exuvo@exuvo.se>
Subject: [PATCH 5.10 033/130] rt2x00: do not mark device gone on EPROTO errors during start
Date:   Mon,  6 Dec 2021 15:55:50 +0100
Message-Id: <20211206145600.800483109@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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


