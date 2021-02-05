Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE4F311519
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhBEWXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhBEO01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 09:26:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F387FC06121C
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 08:04:52 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id c12so8239927wrc.7
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 08:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=89t0wxVgcAViC2yAru0YBAKL2+x7POMwCo1XfV64GbA=;
        b=Gyr/+8Zow4jddUkYg2RTv078XWHTL1mrNYJFZWlg6TOnLYS4j6DsDFHpMpX9syA5Zp
         GpdflrECai6BrgaRXqOws37aow4H1+MXRKIUkcT5jsLZl21V6eRV2cINw6kqFPJfVNsg
         oVKlyH+5omzFlbRB9Bm6m/XGoCgSo1213o+fZ/8H/mzdo5Z4JEuYQ5fbtKAu0f4IB0d9
         LKY3EfcksSiww2tObjT1bpixIcxfUJlX1P0YtmuSsE1zURSsL06Kp9QSgBryuJjLpoVO
         JzdlZ0mRwSK3WMDw+hgJWQy1zHtV5XWy6IDqtiZfwCYWIfDiJlj5P3pw/uQ4kHfr2/X3
         LMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=89t0wxVgcAViC2yAru0YBAKL2+x7POMwCo1XfV64GbA=;
        b=c8dikdyBmRRuRUeYDj7JpE04ZHXKv9JlfOhniUgkQXoKTABp9mNrryVPClhrMzS3NH
         P1HmSzrMxK9iLNTIezuUvq8ZhQvUGfyrMRb7lxLaMz4WDlwhDa3bnXFgGJJDuM/mmAhS
         I0xcn/ZVpLZzYttSerwvFCfvrmrqTe/HNqBRvf1v+0UZx1/ANBw9QNn5pnrNl7GPitSj
         yMnaIUO9GtKwTuvOs/QnkM7tvlcG2wUr5npx7KtP+O8VBsP7cVXCTQRv8QJTowUyjEGu
         3pGA9W6jJXgnlkpa70Tk417CfgnOGJOvDeG/P/kes0a/j1ONCbhADtRlILIMU+hRNm6Q
         L9lA==
X-Gm-Message-State: AOAM532qPjfAj0gBTIXz8if1U4uIAbtCROmS2RRQ08bikBm23EHi5Lu1
        DSX/14FHVC4IyY5XUQXVow5vZc0B8clIOA==
X-Google-Smtp-Source: ABdhPJzWJftv5XpOh1rYVPJFvo3ePZbSNA5a1AutScVF3xetkIpStdeMVFm08me6OBjlx4lal/TPtA==
X-Received: by 2002:aa7:c884:: with SMTP id p4mr3751166eds.212.1612534479398;
        Fri, 05 Feb 2021 06:14:39 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:496d:ac00:2cf3:6033:5ed5:ddc8])
        by smtp.gmail.com with ESMTPSA id u2sm3950709ejb.65.2021.02.05.06.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:14:39 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [stable-5.4] md: Set prev_flush_start and flush_bio in an atomic way
Date:   Fri,  5 Feb 2021 15:14:38 +0100
Message-Id: <20210205141438.72069-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

One customer reports a crash problem which causes by flush request. It
triggers a warning before crash.

        /* new request after previous flush is completed */
        if (ktime_after(req_start, mddev->prev_flush_start)) {
                WARN_ON(mddev->flush_bio);
                mddev->flush_bio = bio;
                bio = NULL;
        }

The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
flush_bio in md_flush_request. But there is no lock protection in
md_submit_flush_data. It can set flush_bio to NULL first because of
compiler reordering write instructions.

For example, flush bio1 sets flush bio to NULL first in
md_submit_flush_data. An interrupt or vmware causing an extended stall
happen between updating flush_bio and prev_flush_start. Because flush_bio
is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
flush bio1 updates prev_flush_start after the interrupt or extended stall.

Then flush bio3 enters in md_flush_request. The start time req_start is
behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
again. INIT_WORK() will re-initialize the list pointers in the
work_struct, which then can result in a corrupted work list and the
work_struct queued a second time. With the work list corrupted, it can
lead in invalid work items being used and cause a crash in
process_one_work.

We need to make sure only one flush bio can be handled at one same time.
So add spin lock in md_submit_flush_data to protect prev_flush_start and
flush_bio in an atomic way.

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
[jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ec5dfb7ae4e1..cc38530804c9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -538,8 +538,10 @@ static void md_submit_flush_data(struct work_struct *ws)
 	 * could wait for this and below md_handle_request could wait for those
 	 * bios because of suspend check
 	 */
+	spin_lock_irq(&mddev->lock);
 	mddev->last_flush = mddev->start_flush;
 	mddev->flush_bio = NULL;
+	spin_unlock_irq(&mddev->lock);
 	wake_up(&mddev->sb_wait);
 
 	if (bio->bi_iter.bi_size == 0) {
-- 
2.25.1

