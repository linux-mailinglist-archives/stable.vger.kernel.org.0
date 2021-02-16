Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9834931D297
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhBPW0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhBPW0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:26:14 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B79C0613D6;
        Tue, 16 Feb 2021 14:25:33 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id e17so13785999ljl.8;
        Tue, 16 Feb 2021 14:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kCSnrPgWBKPuGz6BcK3jpWW2wafXy8uYMenYAYQXXAo=;
        b=SK5NfxgBu+E5KJUrttqO57iuGVHAR1k5YOscj4fR3SL+ak/NLBfSNAcn/hED4Jxx8F
         aUpCsbfPjqVbNgc4DxgP1hbVjNX6s0UBsm4Hq9hxfnpjmEM4io0adjDedF12dkuqjy03
         UrHiJWEq6hT6t6Bd+zUdR3+LPGEbiTVlrRZU//iOutEMmuIuoG8kY9YW8NMiCz6VjHbp
         9CEIjKNsLhzvaPfoByc7+MzGs9lACEJKS8A47ZiNY4E5CMHhP/J3pTzZK5dgLWIwIgJk
         WgFdfgIhY4FulL7CiuYFu/uhTGfyQcnwcJPDiPuXvKKdLocraQM3jV9sb/Q5q/LnobYG
         aPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kCSnrPgWBKPuGz6BcK3jpWW2wafXy8uYMenYAYQXXAo=;
        b=YJKStFZLOpqfoV95TJ6wSwmdWTVacfQ3HFUHncdSnq9WJsYDS0WieUBeqGEDKMM8Tz
         Y8NLB9K7rfQDIpaWyDQWS2MEt2KgWXuYAhdxGMX/kdkIffCkvUI62rIw/U+zjlDAGY57
         /bWvo3+KHklQLPDa3kVefo0Mv8f2Q8iQhyDiguVua/O5f+Wy7tmTnDwFB1KsK/XBv9zM
         JgIi/mqrDYT8VHGrXVp5AaQKXlqqDOdWkh9tItU3KE8ZAgGbaNbtIWkrx8VE+dBdnD8k
         F8ZJivNemzaNn1oOZRq9js0i0fBepqSB3ffI4T1Jt691D65RgPGAJkhuW9QQnGG6Dc5u
         Zd3A==
X-Gm-Message-State: AOAM5339dXtrVgHzb2NopgHWmfbQPtsK8hNBylqIQioRA8u9jl6XMhFa
        pPUhBdI/cSaPA/ugfsR9yO8=
X-Google-Smtp-Source: ABdhPJw9d+5KpTmwKiZm0g7q5mdilyRlFpGRxfAsBx1Fn5lUxBQhhX40SoGa7lwTh8eIcIXz1YczRA==
X-Received: by 2002:a2e:804b:: with SMTP id p11mr13667816ljg.141.1613514332055;
        Tue, 16 Feb 2021 14:25:32 -0800 (PST)
Received: from localhost (crossness-hoof.volia.net. [93.72.107.198])
        by smtp.gmail.com with ESMTPSA id d14sm21366lfg.128.2021.02.16.14.25.30
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 16 Feb 2021 14:25:31 -0800 (PST)
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Chen <peter.chen@freescale.com>,
        Daniel Mack <zonque@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/5] usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
Date:   Wed, 17 Feb 2021 00:24:55 +0200
Message-Id: <1613514299-20668-2-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613514299-20668-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1613514299-20668-1-git-send-email-ruslan.bilovol@gmail.com>
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

