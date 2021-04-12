Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EAE35C066
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbhDLJNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240254AbhDLJKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B018F6128E;
        Mon, 12 Apr 2021 09:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218299;
        bh=CSI6dbRTe9p+rwMBbEBSxBmGC506+71RrdXacmKp01o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtzgUNjjRRTi0sB1uLgrpAz81sXtReGr9SmNNbIGgjK9uKJGGtp7ReKcqBd1vvTqk
         manLBa9/lfqVyit4C3jorTYLYQ5sBq77rDjIMQmO+OPGQy1tm9iEZCQAGI8DXt6Ctn
         eFwqAhYET66Vlt3NValjKZV5nkSD5UOKlT2p33Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Rong Chen <rong.a.chen@intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 128/210] can: uapi: can.h: mark union inside struct can_frame packed
Date:   Mon, 12 Apr 2021 10:40:33 +0200
Message-Id: <20210412084020.280059263@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f5076c6ba02e8e24c61c40bbf48078929bc0fc79 ]

In commit ea7800565a12 ("can: add optional DLC element to Classical
CAN frame structure") the struct can_frame::can_dlc was put into an
anonymous union with another u8 variable.

For various reasons some members in struct can_frame and canfd_frame
including the first 8 byes of data are expected to have the same
memory layout. This is enforced by a BUILD_BUG_ON check in af_can.c.

Since the above mentioned commit this check fails on ARM kernels
compiled with the ARM OABI (which means CONFIG_AEABI not set). In this
case -mabi=apcs-gnu is passed to the compiler, which leads to a
structure size boundary of 32, instead of 8 compared to CONFIG_AEABI
enabled. This means the the union in struct can_frame takes 4 bytes
instead of the expected 1.

Rong Chen illustrates the problem with pahole in the ARM OABI case:

| struct can_frame {
|          canid_t                    can_id;               /* 0     4 */
|          union {
|                  __u8               len;                  /* 4     1 */
|                  __u8               can_dlc;              /* 4     1 */
|          };                                               /* 4     4 */
|          __u8                       __pad;                /* 8     1 */
|          __u8                       __res0;               /* 9     1 */
|          __u8                       len8_dlc;             /* 10    1 */
|
|          /* XXX 5 bytes hole, try to pack */
|
|          __u8                       data[8]
| __attribute__((__aligned__(8))); /*    16     8 */
|
|          /* size: 24, cachelines: 1, members: 6 */
|          /* sum members: 19, holes: 1, sum holes: 5 */
|          /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
|          /* last cacheline: 24 bytes */
| } __attribute__((__aligned__(8)));

Marking the anonymous union as __attribute__((packed)) fixes the
BUILD_BUG_ON problem on these compilers.

Fixes: ea7800565a12 ("can: add optional DLC element to Classical CAN frame structure")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Rong Chen <rong.a.chen@intel.com>
Link: https://lore.kernel.org/linux-can/2c82ec23-3551-61b5-1bd8-178c3407ee83@hartkopp.net/
Link: https://lore.kernel.org/r/20210325125850.1620-3-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/can.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index f75238ac6dce..c7535352fef6 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -113,7 +113,7 @@ struct can_frame {
 		 */
 		__u8 len;
 		__u8 can_dlc; /* deprecated */
-	};
+	} __attribute__((packed)); /* disable padding added in some ABIs */
 	__u8 __pad; /* padding */
 	__u8 __res0; /* reserved / padding */
 	__u8 len8_dlc; /* optional DLC for 8 byte payload length (9 .. 15) */
-- 
2.30.2



