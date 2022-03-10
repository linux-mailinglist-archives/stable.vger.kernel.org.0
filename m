Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551824D4F73
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 17:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiCJQk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 11:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCJQk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 11:40:56 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB285640;
        Thu, 10 Mar 2022 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646930384;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=Cl9sjRgxnYq/vT3JiOhrwxYvJL9HDIU+3FT0Qx31Dqc=;
    b=jc58DKoe3Iq/6XIYtYjOy9LF0ZOKXhhLsgyNLz5mXaM7d5CsSqfL8+LdLspuacGa8z
    Rs7F+KSG21bnm5+MYXTr/AGklLIEag60lFsPFOlfJqSXuMNxcyR95cV48m+zlyVCsXrI
    z7SLrnwzsUyvqlOPYW0xD+SI1LCCUUGA/eD9Q0XNd839pkhs9vcm7OWHl8Jb1LZiLdDQ
    +22tXfbnaQx3I3uSf/uOMBO6bgi71M4p3deihvXBlzK8SVUIFhQ1gIFT9vttM57CygkX
    xsXS4+Dt+pVdpGEtceP4VPjhP55NrIKruQK9XjwbrTGMaN+HF9qEx2AyXcN5jha+yaw3
    wtFw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7gpw91N5y2S3j8N+"
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.40.1 SBL|AUTH)
    with ESMTPSA id 30b171y2AGdi0EG
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 10 Mar 2022 17:39:44 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Subject: Re: [BUG] new MIPS compile error on v5.15.27
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <AF60728F-AF8B-4906-A510-66E880D86ADE@goldelico.com>
Date:   Thu, 10 Mar 2022 17:39:42 +0100
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <66A2A2FB-712D-4484-A0E7-DD6763F8965B@goldelico.com>
References: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
 <20220310162818.GA4436@lst.de>
 <AF60728F-AF8B-4906-A510-66E880D86ADE@goldelico.com>
To:     Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3445.104.21)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Am 10.03.2022 um 17:34 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>=20
>=20
>> Am 10.03.2022 um 17:28 schrieb Christoph Hellwig <hch@lst.de>:
>>=20
>> Please fix <asm/asm.h>.   The most trivial fix might be to only =
defined
>> END() under __ASSEMBLY__, although in the long run it probably wants =
a
>> better name as well.
>=20
> Well
>=20
> a) the bug (name conflict) does not occur in v5.16 or later
> b) I am in no way responsible for either of the patches or subsystems
>=20
> So someone else has to either (partially?) backport
>=20
> commit 348332e000697 ("mm: don't include <linux/blk-cgroup.h> in =
<linux/writeback.h>")
>=20
> to 5.17.y
>=20
> or write your proposed fix just for 5.17.y because it is not required =
elsewhere.

sorry, typo: just for v5.15.y

>=20
> BR and thanks,
> Nikolaus
>=20

