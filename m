Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A300D9EF6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfJPWDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438452AbfJPV7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:17 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D707C20872;
        Wed, 16 Oct 2019 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263157;
        bh=Uh2jeS4GpW90snlql2r8augqkQlGIQcQl7PtYE5jiUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7cSheKyEQ9rpp25lZskA/CKiLupgKniChkogsgq9k8mrB77U9KkVpkz1dh3VrXp/
         vEURQI19S1dqc2FcUI/NL+Ytvy1gjRPTE9z/DzWtUlNrw6tuIqXNjXu5NOAS9/9BnJ
         kSuQO8btQWff6gTqfO58gfMJkFNNuBPN/OV2rLps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 085/112] btrfs: fix balance convert to single on 32-bit host CPUs
Date:   Wed, 16 Oct 2019 14:51:17 -0700
Message-Id: <20191016214904.960760213@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

commit 7a54789074a54f64addf5b49bf1994f478337a83 upstream.

Currently, the command:

	btrfs balance start -dconvert=single,soft .

on a Raspberry Pi produces the following kernel message:

	BTRFS error (device mmcblk0p2): balance: invalid convert data profile single

This fails because we use is_power_of_2(unsigned long) to validate
the new data profile, the constant for 'single' profile uses bit 48,
and there are only 32 bits in a long on ARM.

Fix by open-coding the check using u64 variables.

Tested by completing the original balance command on several Raspberry
Pis.

Fixes: 818255feece6 ("btrfs: use common helper instead of open coding a bit test")
CC: stable@vger.kernel.org # 4.20+
Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3854,7 +3854,11 @@ static int alloc_profile_is_valid(u64 fl
 		return !extended; /* "0" is valid for usual profiles */
 
 	/* true if exactly one bit set */
-	return is_power_of_2(flags);
+	/*
+	 * Don't use is_power_of_2(unsigned long) because it won't work
+	 * for the single profile (1ULL << 48) on 32-bit CPUs.
+	 */
+	return flags != 0 && (flags & (flags - 1)) == 0;
 }
 
 static inline int balance_need_close(struct btrfs_fs_info *fs_info)


