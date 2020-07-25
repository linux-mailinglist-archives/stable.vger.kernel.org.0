Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4B822D80C
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 16:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgGYOXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 10:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgGYOXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 10:23:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CAC2074A;
        Sat, 25 Jul 2020 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595687032;
        bh=HgKb2gMwLhyoVgicuPtR2MT47iWJoelMNq4UC+XQ968=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtPTk/PkmwauIApJUo7+g3hHyOOyUUj6eTTExaOtlePSByjL7a3erBMEzio5DkdKG
         JEyUty6h9YKBmT4C/hm4mzKrirHw6eCac8/mZKLcKxFTGkC3cZANnDSd/gq2JjyYRA
         mHkl0FCQd6aq4baBYiK88Rt6FkKnnSKZLW5Ad7KE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jzL5b-00Er45-3s; Sat, 25 Jul 2020 15:23:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jason Cooper <jason@lakedaemon.net>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Cc:     linux-gpio@vger.kernel.org, marex@denx.de,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2] irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR
Date:   Sat, 25 Jul 2020 15:23:35 +0100
Message-Id: <159568680935.564881.3670480595242978406.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720092328.708-1-yuzenghui@huawei.com>
References: <20200720092328.708-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jason@lakedaemon.net, alexandre.torgue@st.com, tglx@linutronix.de, yuzenghui@huawei.com, linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org, marex@denx.de, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 17:23:28 +0800, Zenghui Yu wrote:
> The GICv4.1 spec tells us that it's CONSTRAINED UNPREDICTABLE to issue a
> register-based invalidation operation for a vPEID not mapped to that RD,
> or another RD within the same CommonLPIAff group.
> 
> To follow this rule, commit f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual
> exclusion between vPE affinity change and RD access") tried to address the
> race between the RD accesses and the vPE affinity change, but somehow
> forgot to take GICR_INVALLR into account. Let's take the vpe_lock before
> evaluating vpe->col_idx to fix it.

Applied to irq/irqchip-5.9, thanks!

[1/1] irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR
      commit: fdccf1d9d10395abfe082f50694f374997c6e101

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


