Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C871910E3
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgCXNS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbgCXNS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D6B208E0;
        Tue, 24 Mar 2020 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055937;
        bh=kD5OmQO4pEKHygBevvv6JpUwmgqLQSgBx1YueWzSU08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uhrv46U7TZhqibXrb6NT33I4CI4EZhAVrDvVKGWz06STVwSBHpzZkHNKqcLt1VLRX
         +z5YrkPLJiYMCAeIQbaglkFgAkEfdkKnNiBpX9byq5fW5vXI5YhmV/WV6izIvQdS2Q
         1YEWybdkFxyXfmwRad1H+BLAjowlGsvsGw7C6Fok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 073/102] intel_th: msu: Fix the unexpected state warning
Date:   Tue, 24 Mar 2020 14:11:05 +0100
Message-Id: <20200324130813.961202332@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 885f123554bbdc1807ca25a374be6e9b3bddf4de upstream.

The unexpected state warning should only warn on illegal state
transitions. Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 615c164da0eb4 ("intel_th: msu: Introduce buffer interface")
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/r/20200317062215.15598-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -718,9 +718,6 @@ static int msc_win_set_lockout(struct ms
 
 	if (old != expect) {
 		ret = -EINVAL;
-		dev_warn_ratelimited(msc_dev(win->msc),
-				     "expected lockout state %d, got %d\n",
-				     expect, old);
 		goto unlock;
 	}
 
@@ -741,6 +738,10 @@ unlock:
 		/* from intel_th_msc_window_unlock(), don't warn if not locked */
 		if (expect == WIN_LOCKED && old == new)
 			return 0;
+
+		dev_warn_ratelimited(msc_dev(win->msc),
+				     "expected lockout state %d, got %d\n",
+				     expect, old);
 	}
 
 	return ret;


