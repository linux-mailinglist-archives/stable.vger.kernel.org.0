Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367DA2E3E78
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502418AbgL1O20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502416AbgL1O20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413CD20731;
        Mon, 28 Dec 2020 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165690;
        bh=q6i4Ow8AMMpZubhmhAaspN9L7Mzo5N5MGBIE6unncE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABS9D5UrL6fyA6BeD13i3QzsCwb/DW0+uuVTd5uOy81qpVMfjVjMlTUizYGwVRGtB
         RXvTTUeCaryPgbEpCz9TNFIu6ML3HYVYX7RxdBEjMdgQf1yWjRcIlytKrzf537407M
         ofEEpj2Ygwg8Rd63fmcZqle8yd/QzYED604v1uxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 621/717] um: Fix time-travel mode
Date:   Mon, 28 Dec 2020 13:50:19 +0100
Message-Id: <20201228125050.679669671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit ff9632d2a66512436d616ef4c380a0e73f748db1 upstream.

Since the time-travel rework, basic time-travel mode hasn't worked
properly, but there's no longer a need for this WARN_ON() so just
remove it and thereby fix things.

Cc: stable@vger.kernel.org
Fixes: 4b786e24ca80 ("um: time-travel: Rewrite as an event scheduler")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -260,11 +260,6 @@ static void __time_travel_add_event(stru
 	struct time_travel_event *tmp;
 	bool inserted = false;
 
-	if (WARN(time_travel_mode == TT_MODE_BASIC &&
-		 e != &time_travel_timer_event,
-		 "only timer events can be handled in basic mode"))
-		return;
-
 	if (e->pending)
 		return;
 


