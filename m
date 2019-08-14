Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA138DF1D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfHNUoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 16:44:11 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:48999 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfHNUoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 16:44:11 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M7sUE-1hu8FB2YJ0-0055JL; Wed, 14 Aug 2019 22:43:59 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Allison Collins <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v5 02/18] xfs: compat_ioctl: add missing conversions
Date:   Wed, 14 Aug 2019 22:42:29 +0200
Message-Id: <20190814204259.120942-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:BLux4Grpb9eaMSbIUHaQDxbpUbrvASwJg7DjSBmbDM1mEh+OQSl
 G5n/FRAlhpcI0Sn7b9m1K0M1bvF39TcpRlT3CSGFl7+bY+KEO6/rjDcP9KSqU+5SOAFZN1u
 Ui5FCJaccug7SCmAt9JgOshsonVvlK697uQkOLkrX2ItPyAMgMpdRzWF2sTnSwRy6q9IT+B
 vD7ThUPi2YJlmDVS6BIww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:j12Xhrp5sIs=:AcxvEsaYOH6PkuvTGntmR9
 rBstK/TIT+tpcug7Gtvy3sx8T18TYIS1QNsHzsO7opM4MdvAyRQ1V4skOOIgSlrGs3uBeEATu
 /N+yQKqh2Gu+2GbVYX0nff3AQUL86sCBbN7G4JifKUsgEMPHFydi+Hmcyny7tZZbhP7++ncih
 fpsI2yzVH6Lnpy3A9z3mck/PxWig+lwGeUZt5MDJsX9HlxJ/kFTcpwVKN4BPCc/3IZ27XgOXQ
 HH5TaXVkv8VI8YHQCYI6SBQAmRV9RoXRoSIqyFyegh330OEmMuAnP9EReovhA05uOQ8OW0XP5
 xh2ytmeOS2tRrdJARoUnKb5xbD+nYMaYPi7+b4kMJl196CCptyCefwvUbziLAPr4ts9iiCiqs
 O1e6cJUptwG/2NA7z6akcuZ06wk3DmFQaav41eBF9gIkMlcNgNvpLh/jlKKfd0xEz5gB3N5S6
 DXhbGKUWiNf+855BcAuf0kc0w0GgIvx7lj8hhbJdxUN6aWHfOq7JPnHAt8QBl8R7fPGIqS0BS
 ECc0EtMgsqvGz3C0pg/V7dudPnK1nNFUp+aU+i402P3pu5XPsUwRCz8rY/ibQjm2Lio2Mxmax
 sq4jjrMpF9qbB9Sh3zPov66UEVbUIkfFNJkaJAFGjq6aOu43e1l6X7mDcZwhfjihaRCGfmVCo
 mtEJYVporJWn+f9fQkLw37RF4eVZR37mnkEcQ77mc0dJa597PDGmwzgVloGPpFGa20ap9mu1I
 L90m3jpTIa7fD6mAaFYIMPPayNuFFuuNZRWOmA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FS_IOC_GETFSLABEL/FS_IOC_SETFSLABEL were added in linux-4.18
in xfs, but not in the compat_ioctl case, so add them here.

FITRIM was added earlier and also lacks a line the same function,
but this is ok because there is an entry in fs/compat_ioctl.c for
it.

Adding all three here to keep the native and compat ioctl handlers
in sync.

Cc: stable@vger.kernel.org
Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ad91e81a2fcf..63bdc4c1535b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -576,6 +576,9 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
 	case XFS_IOC_INUMBERS:
+	case FITRIM:
+	case FS_IOC_GETFSLABEL:
+	case FS_IOC_SETFSLABEL:
 		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
-- 
2.20.0

