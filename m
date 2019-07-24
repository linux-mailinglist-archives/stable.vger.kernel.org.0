Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E6973E7C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389925AbfGXTj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389092AbfGXTjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674AF229F3;
        Wed, 24 Jul 2019 19:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997164;
        bh=QhTgdraJMeg8h3JGFMS4X2SbX+drcBS1wC/WjCfCPYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYMbDUsaHEdCIsEJph2Gk4QduRG2B1wDEuFazvgcj0qaYeQKvxPI5ARLTFp/6JifQ
         DvHl47Do6Z+E7eDNgIBrhINPthpZm9KZTIMMJZJLrFrdquR79jr4wgvz+5eRrTaKkV
         VdVJxCiBN8qPKeJhVMjYbZ8L08rYGWRrsE7kv3HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dietrich <marvin24@gmx.de>,
        Dmitry Osipenko <digetx@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.2 301/413] opp: Dont use IS_ERR on invalid supplies
Date:   Wed, 24 Jul 2019 21:19:52 +0200
Message-Id: <20190724191757.472117081@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 560d1bcad715c215e7ffe5d7cffe045974b623d0 upstream.

_set_opp_custom() receives a set of OPP supplies as its arguments and
the caller of it passes NULL when the supplies are not valid. But
_set_opp_custom(), by mistake, checks for error by performing
IS_ERR(old_supply) on it which will always evaluate to false.

The problem was spotted during of testing of upcoming update for the
NVIDIA Tegra CPUFreq driver.

Cc: stable <stable@vger.kernel.org>
Fixes: 7e535993fa4f ("OPP: Separate out custom OPP handler specific code")
Reported-by: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
[ Viresh: Massaged changelog ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -682,7 +682,7 @@ static int _set_opp_custom(const struct
 
 	data->old_opp.rate = old_freq;
 	size = sizeof(*old_supply) * opp_table->regulator_count;
-	if (IS_ERR(old_supply))
+	if (!old_supply)
 		memset(data->old_opp.supplies, 0, size);
 	else
 		memcpy(data->old_opp.supplies, old_supply, size);


