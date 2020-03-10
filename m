Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9412117FA01
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgCJNBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbgCJNBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B5920409;
        Tue, 10 Mar 2020 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845312;
        bh=res+kNY6oEd1iav7ZQxfpSu96Lndx0UOZKW8UJxr7Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDhs1oJM1QoYGNbtOL9iZ3BM4NY1QaEJRlJBrtnzw072N+BnBbiNzXIftR7LkDXUW
         SkVi/V/ib2VcaJlM+m228piArqWIVULr1dTcMsBiJ6sn9hAhgrNlOB2ORK/ottpy+t
         YlseRUadRiUOTowpVxcXzRF17NuzT6ZSDg8FhbkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 138/189] ASoC: dapm: Correct DAPM handling of active widgets during shutdown
Date:   Tue, 10 Mar 2020 13:39:35 +0100
Message-Id: <20200310123653.772698923@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit 9b3193089e77d3b59b045146ff1c770dd899acb1 upstream.

commit c2caa4da46a4 ("ASoC: Fix widget powerdown on shutdown") added a
set of the power state during snd_soc_dapm_shutdown to ensure the
widgets powered off. However, when commit 39eb5fd13dff
("ASoC: dapm: Delay w->power update until the changes are written")
added the new_power member of the widget structure, to differentiate
between the current power state and the target power state, it did not
update the shutdown to use the new_power member.

As new_power has not updated it will be left in the state set by the
last DAPM sequence, ie. 1 for active widgets. So as the DAPM sequence
for the shutdown proceeds it will turn the widgets on (despite them
already being on) rather than turning them off.

Fixes: 39eb5fd13dff ("ASoC: dapm: Delay w->power update until the changes are written")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200228153145.21013-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -4749,7 +4749,7 @@ static void soc_dapm_shutdown_dapm(struc
 			continue;
 		if (w->power) {
 			dapm_seq_insert(w, &down_list, false);
-			w->power = 0;
+			w->new_power = 0;
 			powerdown = 1;
 		}
 	}


