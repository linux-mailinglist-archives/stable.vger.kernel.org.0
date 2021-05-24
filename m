Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48238EE2D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhEXPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234605AbhEXPo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186AD61455;
        Mon, 24 May 2021 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870562;
        bh=y8tKCc8MNmhJbgdeqlnUMymJi7u75jq1rEAUQ5u/ucY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiB+I/FFH5Uwu/nQHzG86B2qeDN8GvvCkr42JjF16al5GJOiqI6Ik1sWqsoMNRQ4k
         XZmbGzDWu+SxQlM8elNpe+H73TtAGHaEq1TPelqV/Vk7mZgkH5B8tvtUksXiBy4ybQ
         XryXstM4NzMhsFzgeNwxUbSbbdwclXbl0NVukP54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: [PATCH 4.19 43/49] leds: lp5523: check return value of lp5xx_read and jump to cleanup code
Date:   Mon, 24 May 2021 17:25:54 +0200
Message-Id: <20210524152325.760708853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
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
@@ -318,7 +318,9 @@ static int lp5523_init_program_engine(st
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (ret)
+		goto out;
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {


