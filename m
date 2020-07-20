Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355E52264D3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgGTPsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730257AbgGTPsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B50CD2065E;
        Mon, 20 Jul 2020 15:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260117;
        bh=/JGA2XoDIQuwLgX6TPhZdgryCg4I15FhD3O/4gOBQag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tjn5YY/BfDHct3wykIYin8KjwY+ytQyght2+bdzaE+LjnnnrkpvUm99mVF0Fubqvn
         tCUxPC4P3fs4RzHf1j0YXUMqGuiiZ+fUUnvOGkM7EZBD/uR+9q1lYHXGzM3QvjJMKq
         K2TSPJJyWfgg25yWXlukeOCiO46c1gVOzm5NOxpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 112/125] timer: Fix wheel index calculation on last level
Date:   Mon, 20 Jul 2020 17:37:31 +0200
Message-Id: <20200720152808.435944012@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit e2a71bdea81690b6ef11f4368261ec6f5b6891aa upstream.

When an expiration delta falls into the last level of the wheel, that delta
has be compared against the maximum possible delay and reduced to fit in if
necessary.

However instead of comparing the delta against the maximum, the code
compares the actual expiry against the maximum. Then instead of fixing the
delta to fit in, it sets the maximum delta as the expiry value.

This can result in various undesired outcomes, the worst possible one
being a timer expiring 15 days ahead to fire immediately.

Fixes: 500462a9de65 ("timers: Switch to a non-cascading wheel")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200717140551.29076-2-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -502,8 +502,8 @@ static int calc_wheel_index(unsigned lon
 		 * Force expire obscene large timeouts to expire at the
 		 * capacity limit of the wheel.
 		 */
-		if (expires >= WHEEL_TIMEOUT_CUTOFF)
-			expires = WHEEL_TIMEOUT_MAX;
+		if (delta >= WHEEL_TIMEOUT_CUTOFF)
+			expires = clk + WHEEL_TIMEOUT_MAX;
 
 		idx = calc_index(expires, LVL_DEPTH - 1);
 	}


