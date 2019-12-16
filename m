Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EDF1216D0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfLPSKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbfLPSKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 249E7206B7;
        Mon, 16 Dec 2019 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519837;
        bh=Fd7ChdYtx6FGdMpsIhsq6sadR6GKedj+dYkI6xfVanY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYgaNzf6f31wGO6Sgk4zCJQz8UaORVX+Hj3wvVv+H52HW3ZfBx8WBKEJU6jCq473R
         nT6zXXcj0tRkbgEvpU4vU3wFiIjqiKQRk6vq9Yp//RFKKd/Nbww8O/9EbyKgGxre9F
         4uY8FDROySz5z7su4pNXCl+0mV2DWg23b7I2d8YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.3 090/180] cpuidle: teo: Ignore disabled idle states that are too deep
Date:   Mon, 16 Dec 2019 18:48:50 +0100
Message-Id: <20191216174834.567028096@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 069ce2ef1a6dd84cbd4d897b333e30f825e021f0 upstream.

Prevent disabled CPU idle state with target residencies beyond the
anticipated idle duration from being taken into account by the TEO
governor.

Fixes: b26bf6ab716f ("cpuidle: New timer events oriented governor for tickless systems")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/governors/teo.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -266,6 +266,13 @@ static int teo_select(struct cpuidle_dri
 
 		if (s->disabled || su->disable) {
 			/*
+			 * Ignore disabled states with target residencies beyond
+			 * the anticipated idle duration.
+			 */
+			if (s->target_residency > duration_us)
+				continue;
+
+			/*
 			 * If the "early hits" metric of a disabled state is
 			 * greater than the current maximum, it should be taken
 			 * into account, because it would be a mistake to select


