Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BB137D2F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgAKJyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgAKJya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:54:30 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D23A2084D;
        Sat, 11 Jan 2020 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736470;
        bh=UhKWdznl3WaIfp7JHn+VhYkc7uxuSFKGbwszSTT+IcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0zrGyHAhCN/0UxwvTBKOyPX+sXP+DQ3c0yn46Dmbv21TQxgK8LJGBOYZtD3so4RU
         3h63o/qne+czeU/WtwSOnHe/W2EytzaGrt8tAIeirxFd7hOZq2JW7/laknGihzRc73
         P7govJrrDuCyXWOi2RNh7RRrdLB3d5g1X0qb8tKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 21/59] ALSA: cs4236: fix error return comparison of an unsigned integer
Date:   Sat, 11 Jan 2020 10:49:30 +0100
Message-Id: <20200111094843.080946833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit d60229d84846a8399257006af9c5444599f64361 upstream.

The return from pnp_irq is an unsigned integer type resource_size_t
and hence the error check for a positive non-error code is always
going to be true.  A check for a non-failure return from pnp_irq
should in fact be for (resource_size_t)-1 rather than >= 0.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: a9824c868a2c ("[ALSA] Add CS4232 PnP BIOS support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20191122131354.58042-1-colin.king@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/isa/cs423x/cs4236.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -293,7 +293,8 @@ static int snd_cs423x_pnp_init_mpu(int d
 	} else {
 		mpu_port[dev] = pnp_port_start(pdev, 0);
 		if (mpu_irq[dev] >= 0 &&
-		    pnp_irq_valid(pdev, 0) && pnp_irq(pdev, 0) >= 0) {
+		    pnp_irq_valid(pdev, 0) &&
+		    pnp_irq(pdev, 0) != (resource_size_t)-1) {
 			mpu_irq[dev] = pnp_irq(pdev, 0);
 		} else {
 			mpu_irq[dev] = -1;	/* disable interrupt */


