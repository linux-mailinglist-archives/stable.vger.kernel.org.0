Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C038F044
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhEXQCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhEXQA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E88C61996;
        Mon, 24 May 2021 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871190;
        bh=0DVwXL7PYrs3JfPmlESgZ3BmiRo0C+ub21RL2mKSP9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhQg0Btm4kEmybwQUjTIKckWrqbiVnD8W5F6To0UHV4znDdIpXu15aj7PY58F7Tyn
         KkXkHrdFhiCx//WfARdsWy71WjlJyS5vk+Zj4qnu6Ua48j6w75fa4qhnpcVlOD2edK
         q+VR0uXsnLIzRg+UmlzLzVXW5wHyVZf581QOsnHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: [PATCH 5.12 115/127] leds: lp5523: check return value of lp5xx_read and jump to cleanup code
Date:   Mon, 24 May 2021 17:27:12 +0200
Message-Id: <20210524152338.751211928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit 6647f7a06eb030a2384ec71f0bb2e78854afabfe upstream.

Check return value of lp5xx_read and if non-zero, jump to code at end of
the function, causing lp5523_stop_all_engines to be executed before
returning the error value up the call chain. This fixes the original
commit (248b57015f35) which was reverted due to the University of Minnesota
problems.

Cc: stable <stable@vger.kernel.org>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-10-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,7 +305,9 @@ static int lp5523_init_program_engine(st
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (ret)
+		goto out;
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {


