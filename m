Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148CE30C12E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhBBOPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234209AbhBBON0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA2796504F;
        Tue,  2 Feb 2021 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273987;
        bh=y+/6JOiMOOSr3Rf4Ca/V6WVy1L6mHxCIbGUPnkTn6AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuhoLbfOZx379hbLOHbZzq7O8rkqyFtPayI2YxJqAfuferDfWu2xyauiC7asw5p0u
         UANtFPAgWzIYmCpPo4fufEqLP4OV1OTI28OdbUviM8vMvJ9DctM6QvH2z/iV60A9Kf
         ZuBohQmnNUaZ3PyRHBHeigt52eBBTyIxqteyjah4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Badel <laurentbadel@eaton.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 10/37] PM: hibernate: flush swap writer after marking
Date:   Tue,  2 Feb 2021 14:38:53 +0100
Message-Id: <20210202132943.325340169@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Badel <laurentbadel@eaton.com>

commit fef9c8d28e28a808274a18fbd8cc2685817fd62a upstream.

﻿Flush the swap writer after, not before, marking the files, to ensure the
signature is properly written.

Fixes: 6f612af57821 ("PM / Hibernate: Group swap ops")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -491,10 +491,10 @@ static int swap_writer_finish(struct swa
 		unsigned int flags, int error)
 {
 	if (!error) {
-		flush_swap_writer(handle);
 		pr_info("S");
 		error = mark_swapfiles(handle, flags);
 		pr_cont("|\n");
+		flush_swap_writer(handle);
 	}
 
 	if (error)


