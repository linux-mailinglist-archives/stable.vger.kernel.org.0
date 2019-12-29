Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833E212C894
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbfL2R4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733048AbfL2R4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE138206A4;
        Sun, 29 Dec 2019 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642177;
        bh=VW+qIUu6RqVsLu8Q4CcxWUpymHkMjIldu2eAa67YQ4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T93ClrgUtbyIcuLgoQ+wszDvgCnz8S3K4HeVvga5lcLh1R3e1i5VOe/X4QN3o2VZ2
         DyvF8rfjnG+X0gNVWzUYFpsG/Sivo/S4fuv4+29eo2kYjCBSavlIiYhJIb6rQ15RUh
         xOUX/tQ03hQasV0FNPZ5Kh50TAcmaCTjBFQlCskk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 331/434] net-af_xdp: Use correct number of channels from ethtool
Date:   Sun, 29 Dec 2019 18:26:24 +0100
Message-Id: <20191229172723.956387676@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luigi Rizzo <lrizzo@google.com>

[ Upstream commit 3de88c9113f88c04abda339f1aa629397bf89e02 ]

Drivers use different fields to report the number of channels, so take
the maximum of all data channels (rx, tx, combined) when determining the
size of the xsk map. The current code used only 'combined' which was set
to 0 in some drivers e.g. mlx4.

Tested: compiled and run xdpsock -q 3 -r -S on mlx4

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20191119001951.92930-1-lrizzo@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a73b79d29333..70f9e10de286 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -344,13 +344,18 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (err || channels.max_combined == 0)
+	if (err) {
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
 		ret = 1;
-	else
-		ret = channels.max_combined;
+	} else {
+		/* Take the max of rx, tx, combined. Drivers return
+		 * the number of channels in different ways.
+		 */
+		ret = max(channels.max_rx, channels.max_tx);
+		ret = max(ret, (int)channels.max_combined);
+	}
 
 out:
 	close(fd);
-- 
2.20.1



