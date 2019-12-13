Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABF11DC1F
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 03:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbfLMCbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 21:31:38 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40422 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731330AbfLMCbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 21:31:38 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so621698pfh.7;
        Thu, 12 Dec 2019 18:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwpeGjmnfuoMNodJxH1qqlcQ4ceXry1kM/GE4cUt360=;
        b=Ig/3FDil1XBe7TMbnNFatTTHH+Z4vR6bke278InL188wJrQ9DO5uhXv/3Xe8HKpnHi
         4ev8PfRD1/0LIGHsIAc/uMJ4MgVI0TdXytpWOXxBCXyu24OHQrGXM8/99aPYX/XVVk2a
         3iBzk7hq04axFjOQOJg/xUe2tV2rCYgweb7qup0RKABAAWLab9/mRLket5lUdFcEWdUs
         F1il50L8w/iI6dQSRCENr4/7t48MYNmg+VO/GGoaicnTpQjOJeor5MyjGCA9w43Wjl6F
         n3sAMZInzhiAdh7kuOaaF/aPA9NEg2EcB48Zysx8Wjohw2Kz9m9CqtwTJN9rFYgEUlvH
         FAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwpeGjmnfuoMNodJxH1qqlcQ4ceXry1kM/GE4cUt360=;
        b=hwV+/d1x4AFQNbRxHj938a+0Wbbn2xoKDchFfZU3Ghy2WWLMxBNrKy5BLlmogZDYht
         Q8ttysH6ndc+cae4eVZ4aLHN3EKzB6J+f99ML5TnjLVh3C3qAQ4edX36wnW3YxZ7pV3m
         xLUNBC2tcTkINWUtfD0FazRQWRDmE/SPD1+wDyU6ZZGC4HP3yQZdpvMpaz6e90BaihU1
         KaoTO3mMe9MsP/ioR+QUkYyAiS5moPLnnRsilBcOlbiAl5MY2+WiM9Mk0HJHLpgR0WqY
         c/qagrutNqkryuPxeKgMr04LStcu+dB9EgUElgNSuj5+FWzSNHwj1ucAofzyCK8+xAdv
         oovA==
X-Gm-Message-State: APjAAAVvsOULSpB2BNcu7aqjYeglCXHSpVM2/mafYv5tyHxxrr2XoJ21
        9oT0ukPAsJLeKI2mBeDUICc=
X-Google-Smtp-Source: APXvYqxIutMG4PWuFmKKIVkujL0jQkDxOF/aHzjaDXUNuF0FySs/kuqqivCyl1zcITLgXexw2Wcesw==
X-Received: by 2002:a65:5608:: with SMTP id l8mr14517216pgs.210.1576204297724;
        Thu, 12 Dec 2019 18:31:37 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h68sm9443654pfe.162.2019.12.12.18.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 18:31:37 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH v2 1/2] usbip: Fix receive error in vhci-hcd when using scatter-gather
Date:   Fri, 13 Dec 2019 11:30:54 +0900
Message-Id: <20191213023055.19933-2-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213023055.19933-1-suwan.kim027@gmail.com>
References: <20191213023055.19933-1-suwan.kim027@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When vhci uses SG and receives data whose size is smaller than SG
buffer size, it tries to receive more data even if it acutally
receives all the data from the server. If then, it erroneously adds
error event and triggers connection shutdown.

vhci-hcd should check if it received all the data even if there are
more SG entries left. So, check if it receivces all the data from
the server in for_each_sg() loop.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
---
 drivers/usb/usbip/usbip_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 6532d68e8808..e4b96674c405 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 
 			copy -= recv;
 			ret += recv;
+
+			if (!copy)
+				break;
 		}
 
 		if (ret != size)
-- 
2.20.1

