Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1766B327D9A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhCALvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhCALv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:51:29 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021D0C0617A9;
        Mon,  1 Mar 2021 03:50:21 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id v5so24966385lft.13;
        Mon, 01 Mar 2021 03:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kCSnrPgWBKPuGz6BcK3jpWW2wafXy8uYMenYAYQXXAo=;
        b=ixXnxuODlm2F2/qR4/+z9QOP7DQ2Tv9Y9+M9g3Ly/2uj5LrZUXvMEU0cXAZTtg2aUw
         +bLH402RiaO1KQ4eW/1Kv8q/cYudmsh/h47IiEKzgW+BzePOV44pvxD5lV9EkRlLnlEQ
         /NTlBceHzJLbwmqDOTbLJUrI56z+CO/oF99kdd73HJsq+i6ml99ShEHtm4aI9rZWSdas
         IoU+VF5aBBOVNtoIA9kV5HB3HYjAgAd2IPOk+BKUHcsT3FdqrFCNL9+/knCYcfStpZna
         4BlYbOSBBri7nDNXt8YDSeDiyOqJKzQfncczK7UxMzUeixOmmTHNUXrgbZKv8RFxOczN
         0auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kCSnrPgWBKPuGz6BcK3jpWW2wafXy8uYMenYAYQXXAo=;
        b=nwYoe4JTtJwhfM8BYWW96tmfUj2CX4qzA3EyQpLPAionhDeSRdh3ZsLF7GNNhYcO3Z
         ABD8oBLrNVb4x2WXr7P+woR6Q2zsliwhyGcRRltsPyrWMbxBAcm8MiGDV3pPZxhCe68f
         /5HLOPXa4TJOOp0l0uroe76ULhyiuR1pM7H0taklZPIbnzKMuUp9TdgvzbxEZCa0eSni
         KHYkKZJiy4WB8epFfBcbYEkVBckBtjFZtSZ7zFknvbPPPluNgqNYRaMKdqty93X/J63B
         Kk1HAhlA05S39H8JczUe567e/cMAHUaI6AYvcFHcfRX2yWvTwo4c2+iXag/gCJG5HiGu
         DBPQ==
X-Gm-Message-State: AOAM531lxVYlR6LPvSxS0bodiA0hbzY/czRvBqbIhlN2Kn7zBeLGai8w
        wvZQsB3a1pnhucX1wwV93Ew=
X-Google-Smtp-Source: ABdhPJyokDtKQtzOKsb/vCYkQe0nbmlLP3DSQqMH7gBZQQStxdlyXqta4Ik8QM5CqEZ1N2Zax6ZzhA==
X-Received: by 2002:ac2:48b1:: with SMTP id u17mr9958917lfg.627.1614599419562;
        Mon, 01 Mar 2021 03:50:19 -0800 (PST)
Received: from localhost (crossness-hoof.volia.net. [93.72.107.198])
        by smtp.gmail.com with ESMTPSA id u3sm2284253lff.225.2021.03.01.03.50.18
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 01 Mar 2021 03:50:18 -0800 (PST)
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Peter Chen <peter.chen@freescale.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/5] usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
Date:   Mon,  1 Mar 2021 13:49:31 +0200
Message-Id: <1614599375-8803-2-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1614599375-8803-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1614599375-8803-1-git-send-email-ruslan.bilovol@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per UAC2 Audio Data Formats spec (2.3.1.1 USB Packets),
if the sampling rate is a constant, the allowable variation
of number of audio slots per virtual frame is +/- 1 audio slot.

It means that endpoint should be able to accept/send +1 audio
slot.

Previous endpoint max_packet_size calculation code
was adding sometimes +1 audio slot due to DIV_ROUND_UP
behaviour which was rounding up to closest integer.
However this doesn't work if the numbers are divisible.

It had no any impact with Linux hosts which ignore
this issue, but in case of more strict Windows it
caused rejected enumeration

Thus always add +1 audio slot to endpoint's max packet size

Fixes: 913e4a90b6f9 ("usb: gadget: f_uac2: finalize wMaxPacketSize according to bandwidth")
Cc: Peter Chen <peter.chen@freescale.com>
Cc: <stable@vger.kernel.org> #v4.3+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
---
 drivers/usb/gadget/function/f_uac2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 740cb64..c62cccb 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -478,7 +478,7 @@ static int set_ep_max_packet_size(const struct f_uac2_opts *uac2_opts,
 	}
 
 	max_size_bw = num_channels(chmask) * ssize *
-		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
+		((srate / (factor / (1 << (ep_desc->bInterval - 1)))) + 1);
 	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
 						    max_size_ep));
 
-- 
1.9.1

