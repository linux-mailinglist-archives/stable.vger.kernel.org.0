Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACF2A6F55
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 22:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgKDVD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 16:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbgKDVD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 16:03:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAD9207BB;
        Wed,  4 Nov 2020 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604523805;
        bh=Lw2cFOKwfSS8qjbqH7mUO+SKrczM91SIF7GGJoKm9lc=;
        h=From:To:Cc:Subject:Date:From;
        b=jrl9rWiSqILQ4nnDe7zyO22nqpayaNb3/a12Bnr8MA9g7v2Zg/CU53shESb1QFpLS
         p9VIgPbCXdb8GuLFKhi9aEPR4elvKxvn8VdxX9BefESIEm7nfNCd1vZYgFGpYDOk4S
         +xMaAYWHAWBtnyY7Q/jjvf5Rc3DCKhqer1BB2pVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        =?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.4
Date:   Wed,  4 Nov 2020 22:04:14 +0100
Message-Id: <16045237196633@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.4 kernel.

This is only a bugfix for the 5.9.3 kernel release which had some
problems with some symlinks for the powerpc selftests.  This problem was
caused by issues in going from git->patch->quilt->git and things got a
bit messed up.  To resolve this, I reverted the offending patch and a
prerequsite one, and then used 'git cherry-pick' to backport the patches
properly, which preserved the links correctly.

Many thanks to Marc Aurèle La Franc and others for helping me notice
this and provide some solutions for it.

If you had no issues with these files in 5.9.3, no need to upgrade at
this time.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S       |  243 -----------
 tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S |    1 
 3 files changed, 2 insertions(+), 244 deletions(-)

Dan Williams (2):
      x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
      x86/copy_mc: Introduce copy_mc_enhanced_fast_string()

Greg Kroah-Hartman (3):
      Revert "x86/copy_mc: Introduce copy_mc_enhanced_fast_string()"
      Revert "x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()"
      Linux 5.9.4

