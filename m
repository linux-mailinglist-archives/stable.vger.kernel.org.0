Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01A72856
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGXGfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:35:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44339 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 02:35:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so20376476pfe.11;
        Tue, 23 Jul 2019 23:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UIc+sGFrUq7b/rZz1VSObEDqL5JaiIGysAR5vDj6tl0=;
        b=m9HXistGgqARorUww5a3WlemXpE24rwkdJkxB6P3xPNr56yMk5y9IS32XxKMgkSEUP
         Cn94VUUZxJv46OjuNJZCb9tKQylDWCUCAj1t843D+fSzPAVYP4yNM4/aThpkbrN1d8Dw
         d26vvQ8JCx3Q6M65DczuZ6l83vckXbGFoQyw0VCeUzfyrdP71kzSKxfDLSTQxHSqd+cY
         mLCqGJ2r979NYpsvqKNjwLM3jHMo4jcpJUA1aIxPhfMfVyefe4sjI/OLRtz6mQTIB/yD
         l93fOfa+da1z/nEpndO+4SWTqWu93pRyjw/MXlUU01DfG2B6KfuBuQQUgUueuwTMAENK
         8hnA==
X-Gm-Message-State: APjAAAUwOuPSglcLNfQK9xtYIjcEcdNuX3lvMCM5iT1a5XS9ajl82CiV
        vG8UHlmtXGsJ9ciOVwL2nVQ=
X-Google-Smtp-Source: APXvYqydZF6/W7yFxLtsdUSh392mpvbMfWpsdkmgKzL+TvOOYyQX7aUVPH0thpkr24kv+d2a47rhBw==
X-Received: by 2002:a63:360d:: with SMTP id d13mr79931641pga.80.1563950100230;
        Tue, 23 Jul 2019 23:35:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i14sm72646774pfk.0.2019.07.23.23.34.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:34:59 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 69589402A1; Wed, 24 Jul 2019 06:34:58 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/6] xfs: stable fixes for v4.19.y - circa v4.19.60
Date:   Wed, 24 Jul 2019 06:34:45 +0000
Message-Id: <20190724063451.26190-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

you merged my last set of XFS fixes. I asked for one patch to not be
merged yet as one issue was not yet properly fixed. After some further
review I have identified commits which do fix the kernel crash reported
on kz#204223 [0] with generic/388, this patch set applies on top of the
last one I sent you.

These commits do quite a bit of code refactoring, and the actual fix
lies hidden in the last commit by Darrick. Due to the amount of changes
trying to extract the fix is riskier than just carring the code
refactoring. If we're OK with the code refactor for stable, its my
recommendation we keep the changes to match more with upstream and
benefit from other fixes. The code refactoring was merged on v4.20 and
Darrick's fix is the only fix upstream since the code was merged.

If others disagree with this approach please speak up.

I've run a full set of fstests against the following sections 12 times and
have found no regressions against the baseline:

xfs
xfs_logdev
xfs_nocrc_512
xfs_nocrc
xfs_realtimedev
xfs_reflink_1024
xfs_reflink_dev

Review from others is appreciated.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204223

Allison Henderson (4):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  xfs: Add helper function xfs_attr_try_sf_addname
  xfs: Add attibute set and helper functions
  xfs: Add attibute remove and helper functions

Brian Foster (1):
  xfs: don't trip over uninitialized buffer on extent read of corrupted
    inode

Darrick J. Wong (1):
  xfs: always rejoin held resources during defer roll

 fs/xfs/libxfs/xfs_attr.c       | 231 ++++++++++++++++++---------------
 fs/xfs/{ => libxfs}/xfs_attr.h |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  54 +++++---
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_defer.c      |  14 +-
 fs/xfs/xfs_dquot.c             |  17 +--
 6 files changed, 183 insertions(+), 136 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (98%)

-- 
2.18.0

