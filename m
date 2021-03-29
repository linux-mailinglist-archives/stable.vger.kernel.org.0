Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645434CA10
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhC2Ier (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234743AbhC2Ide (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1770F61932;
        Mon, 29 Mar 2021 08:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006803;
        bh=0IXQZf3dDztMvaSdtq5qt7YZM/yfrIAaDdJhNr36Yog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dknb7O4hiEE5EGl3w3+isGKNSP1pp7s7OPa5In0IV2Zj2l3UU69UXD0N8q5S3mOps
         lKzDIEIu1+NE7DWn3nvPoKl8XF23zEFpPVXA+jtkfmuSGKkIHMJNnM8QJLh04CYivm
         Ac161UZGngBlGaEhS+at6OAmRqQIzHbebyaiy2kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JeongHyeon Lee <jhs2.lee@samsung.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 103/254] dm verity: fix DM_VERITY_OPTS_MAX value
Date:   Mon, 29 Mar 2021 09:56:59 +0200
Message-Id: <20210329075636.588569772@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JeongHyeon Lee <jhs2.lee@samsung.com>

commit 160f99db943224e55906dd83880da1a704c6e6b9 upstream.

Three optional parameters must be accepted at once in a DM verity table, e.g.:
  (verity_error_handling_mode) (ignore_zero_block) (check_at_most_once)
Fix this to be possible by incrementing DM_VERITY_OPTS_MAX.

Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,7 +34,7 @@
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 
-#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC + \
+#define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;


