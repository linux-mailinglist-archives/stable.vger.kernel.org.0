Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA92B3A643C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbhFNLWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236010AbhFNLUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A434461468;
        Mon, 14 Jun 2021 10:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667904;
        bh=NlyYz677VQ1YSl9go32taC6oUabOYNPti/10awgTDsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djsHrcJfHdO4iCxbtkwV983pccySERpMpYipwFv2BI4EUX7atPIsKcT4BUZnqlwF+
         zRkRjdYMWHn8Q1ooDrK/POUUpmYG4EkJpJT802+4F3K42kZP5jw08dJK7qdBDud99o
         XcyMummF+88D9cFioZeNMutsd6+lPxeXZ7MKZHNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 119/173] regulator: scmi: Fix off-by-one for linear regulators .n_voltages setting
Date:   Mon, 14 Jun 2021 12:27:31 +0200
Message-Id: <20210614102702.122535731@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 36cb555fae0875d5416e8514a84a427bec6e4cda upstream.

For linear regulators, the .n_voltages is (max_uv - min_uv) / uv_step + 1.

Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20210521073020.1944981-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -176,7 +176,7 @@ scmi_config_linear_regulator_mappings(st
 		sreg->desc.uV_step =
 			vinfo->levels_uv[SCMI_VOLTAGE_SEGMENT_STEP];
 		sreg->desc.linear_min_sel = 0;
-		sreg->desc.n_voltages = delta_uV / sreg->desc.uV_step;
+		sreg->desc.n_voltages = (delta_uV / sreg->desc.uV_step) + 1;
 		sreg->desc.ops = &scmi_reg_linear_ops;
 	}
 


