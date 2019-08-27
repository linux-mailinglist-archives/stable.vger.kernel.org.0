Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A519DF51
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfH0HxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbfH0HxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4613B2173E;
        Tue, 27 Aug 2019 07:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892388;
        bh=SQhY+TpsZ2oEYPOt8K5AAC0iYYzjOFc5UyErPw4oMUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIwVDc8ICyPqA97Ys4hu8V4ctfwjKsmlhsu+704kSvEsyKXmUoaLYRKYNG1P7/vZz
         8ZgX0F4EuJmAoLpLJoJHICSEnmXy01W1Fbx4PVhV2AAD3nW20L0LQPUrOVl+yjkvg5
         rQsGxgFekr5HiAj+XSqhfhwmvDjSRprKcKwYrhEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 37/62] HID: wacom: Correct distance scale for 2nd-gen Intuos devices
Date:   Tue, 27 Aug 2019 09:50:42 +0200
Message-Id: <20190827072702.809864350@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit b72fb1dcd2ea9d29417711cb302cef3006fa8d5a upstream.

Distance values reported by 2nd-gen Intuos tablets are on an inverted
scale (0 == far, 63 == near). We need to change them over to a normal
scale before reporting to userspace or else userspace drivers and
applications can get confused.

Ref: https://github.com/linuxwacom/input-wacom/issues/98
Fixes: eda01dab53 ("HID: wacom: Add four new Intuos devices")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -848,6 +848,8 @@ static int wacom_intuos_general(struct w
 		y >>= 1;
 		distance >>= 1;
 	}
+	if (features->type == INTUOSHT2)
+		distance = features->distance_max - distance;
 	input_report_abs(input, ABS_X, x);
 	input_report_abs(input, ABS_Y, y);
 	input_report_abs(input, ABS_DISTANCE, distance);


