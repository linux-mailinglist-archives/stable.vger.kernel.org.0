Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE374D4F54
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 17:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbiCJQcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 11:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbiCJQcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 11:32:15 -0500
X-Greylist: delayed 181 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 08:31:13 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BEE190C20
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 08:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646929509;
    s=strato-dkim-0002; d=goldelico.com;
    h=Message-Id:To:Cc:Subject:Date:From:Cc:Date:From:Subject:Sender;
    bh=C3MEEvCsdntcFwNwoUEd0O6fo1BIx8o+x380PB9R+7M=;
    b=GOLa/OjKY2zqL4xNZwYxwSSB7+toziQGOiRD3MY7ZkR1ZGMOVcgGIzM1WYOJbJXWEH
    WAOFL+OUljB4S0o8HMGA+c660JZWi1IVYg28XQHcblXiVxJGkpGNIA+I7PoxsdFRiETk
    hP0KkClTdS80KkXV7+dq0MztIVs6w4djZCiDnNCS2d9JCzrBBrQHQAlDchRxD77ot7I4
    uIZgkfuv+NEsf+Hj3Lhe8quMRJ6SUW8buyTClg3JaPYL4fmVbD73fiL2/7RsXvDgAl4R
    pCoarUPr8/ISQg2jc2tkDfVtz8vHU9Vd6BsybBA+DD36dlThLVnNNRQF5ZnJG5Ox3ULL
    bTRA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7gpw91N5y2S3j8N+"
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.40.1 SBL|AUTH)
    with ESMTPSA id 30b171y2AGP80Aq
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 10 Mar 2022 17:25:08 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Date:   Thu, 10 Mar 2022 17:25:07 +0100
Subject: [BUG] new MIPS compile error on v5.15.27
Cc:     stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
To:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@lst.de>
Message-Id: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
X-Mailer: Apple Mail (2.3445.104.21)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 277c8cb3e8ac ("MIPS: fix local_{add,sub}_return on =
MIPS64")

was backported to v5.15.27 as

commit f98371d2ac83 ("MIPS: fix local_{add,sub}_return on MIPS64")

but breaks MIPS build:

In file included from ./arch/mips/include/asm/local.h:8:0,
                 from ./include/linux/genhd.h:20,
                 from ./include/linux/blkdev.h:8,
                 from ./include/linux/blk-cgroup.h:23,
                 from ./include/linux/writeback.h:14,
                 from ./include/linux/memcontrol.h:22,
                 from ./include/net/sock.h:53,
                 from ./include/linux/tcp.h:19,
                 from drivers/net/slip/slip.c:91:
./arch/mips/include/asm/asm.h:68:0: warning: "END" redefined
 #define END(function)     \
=20
In file included from drivers/net/slip/slip.c:88:0:
drivers/net/slip/slip.h:44:0: note: this is the location of the previous =
definition
 #define END             0300  /* indicates end of frame */

Analyses reveals that with the backported MIPS fix there is a new
#include <asm/asm.h> introduced by ./arch/mips/include/asm/local.h
which already defines some END macro.

But why does v5.16.x compile fine where

commit a0ecfd10d669c ("MIPS: fix local_{add,sub}_return on MIPS64")

is also present since v5.16.3?

Deeper analyses shows that there is another patch introduced
in v5.16-rc1 which removed one #include in the above chain and
therefore does not define END by asm/asm.h:

commit 348332e000697 ("mm: don't include <linux/blk-cgroup.h> in =
<linux/writeback.h>")

Hence, the MIPS fix should only be applied to branches where
the mm fix is already present. Or the mm fix should be backported
as well (if it has no side-effects).

Note: the MIPS fix was apparently not (yet?) applied to v5.10.y or =
earlier
even tough the Fixes: 7232311ef14c ("local_t: mips extension")
would be true.

BR and thanks,
Nikolaus Schaller

