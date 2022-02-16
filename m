Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0E74B883F
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiBPMy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:54:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiBPMy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:54:56 -0500
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 04:54:44 PST
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B034241DB3
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 04:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1645016082;
        bh=6n8IyqiFN/c7FWIW1+V/9i22pWGQM3z0cxtRVSRiXiY=;
        h=X-UI-Sender-Class:Date:To:References:From:Subject:In-Reply-To;
        b=a51diJ+OBjgYDG6dQwbzP2yEDVHSXMWEjVXCTEw1+hHsSh0Ny6viF4GMb7/T4Bkdh
         Mmt+ODhDtXX8y+EL9rgrKSeF1UyOri5gG5BGm9QHWLB2PgEfMez2C5siilL0MWv4lI
         9L41K3HLaicmndQeNlUD0hyU0NBkUpkSL5WdnxVE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M5wPh-1nNKgI0XN5-007YoB; Wed, 16
 Feb 2022 13:49:33 +0100
Message-ID: <1e93f7ce-b5c2-e0aa-9323-27d9b8bdee27@gmx.com>
Date:   Wed, 16 Feb 2022 20:49:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1644994950.git.wqu@suse.com>
 <d2ce0079f3d2144876f019575858b392263089c4.1644994950.git.wqu@suse.com>
 <20220216123759.GP12643@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH for v5.15 2/2] btrfs: defrag: use the same cluster size
 for defrag ioctl and autodefrag
In-Reply-To: <20220216123759.GP12643@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vtzJR/3/VQbEAHo4UOwhz7W3rDqf+O78XQLztq7qMzArbQTYiZm
 RfrzlLTHdFDXDTL8coLGP83SMTLVnhedkM/82Il+RPfibhqbdzU0SAkE0afv9BKhtlmEdfI
 YEQqDUOJoMxBCZvqzaKLbAlQ6cjkTrTwANpGu+4X9ZoS3mEI5p66+xVJWhaqWIHmgTMuxXX
 cfMqhvZK9Vj/yFtypcvJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YkGeyKiJOQE=:JE9rAwgl4+xp7HeSvKf0WL
 W45P5ZGrXCwdWxXGTmz4Bzet+Pwv1vck2PTfLcRyLtKwB7Dal9nrQQeZiN2kODucMVVGBIn9T
 G5z2pfLXYYql1gHmlEPrekp33KsYgP81XjHmRZxUVikSMajfUPHqLpXiqmR/lQTZIbewdpj1N
 abRvXlY8J5YWKulfF1/VlNqCv6WCksO75oMmeJhpyHeElLjA5pshCwstkrSHvX4TeqrxrazNz
 +xiIVxWq64zMfYrraoIMEEO3RyHTSjip/pbDpX7qnXpw68WVv4jwwt+EFdTL7N5xlIJkt2gSI
 jc8BnrwXfStqQsezZsbsiZ/eaYpDP9q+wVr98RQGEaiFIbVM3fE0PqmyDHPVq2gPPznnlOTsE
 cXksKZF2UmPy1I90JDiFrx8A3Eu+jqxjLY2+Pn2+RQaUOt21xpJAkJoRfYIBje2+uabE5G1c+
 jYxBSbr5k1HWjldjM7YBr158S8R/zzhpoVBCaBfb8ZOB4v3nY9igi+oUNOYoL7wa1ZeV84sVM
 SBDcnzKzsIeQhGL3ERdZDGAa+sgc3L0VVRBXQp09dCs3H/hScoYGO1SHhCLfdJ3wGGCu7k42+
 o279fPpk6GHJPGpMzLSkFgOcFYLtgdMQ6I5oMxrauxB+K9w7pDfv0svc0+LVpxKigwq0sXE5W
 aVTvIqS9IUbPmEGW1vo9/bgigjR2cyoTuhBftqblIUohruo5oPECsOoiRv3BTsD1H/NztRYFD
 OhxeJT7e+qR5SM4icyBvUWsYbM4e4K0CfFIEemvU9wBlsqTB8WWhiXM4qDxC1vVf5RtMMaC0c
 p36VvvujHwfQWs3+fptHjjbiueREEU/i2CpsqCht/+UfaYBBF2VdWomzGFAtPAocUSJLYU8Vw
 7n1iWIqzygjHT2qDKMD+0it74slyohmuRkV+S/gkZYfLBD/iPG7qSDclD68VgOpid4Nz0JxtY
 s4ux/pdoY9ONqt66CPraXs05rNiv7Ol8Z8kJRgEU3mEnvciLs11EfQyijVSFMUCX5NSVoUmu9
 bzqls2r0poK+pLH8zt6uehnzKjPO6aSzZyC98w8PhdaIzi4vOHSS8O4ELca0HjJk0s+AKnG0k
 zfPbOr4yTKf7hk=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/2/16 20:37, David Sterba wrote:
> On Wed, Feb 16, 2022 at 03:09:08PM +0800, Qu Wenruo wrote:
>> No upstream commit.
>> Since the bug only exists between v5.11 and v5.15. In v5.16 btrfs
>> reworked defrag and no longer has this bug.
>
> I'm not sure this will work as a stable patch. A backport of an existing
> upstream patch that is only adapted to older stable code base is fine
> but what is the counterpart of this patch?

The whole ill-fated rework on defrag.

>
>>
>> [BUG]
>> Since commit 7f458a3873ae ("btrfs: fix race when defragmenting leads to
>> unnecessary IO") autodefrag no longer works with the following script:
>
> The bug does no seem to be significant, autodefrag is basically a
> heuristic so if it does not work perfectly in all cases it's still OK.

Normally I'd say yes.

But I don't want to surprise end users by suddenly increase their IO for
autodefrag in the next LTS.

This bug is really setting a high bar (or low IO expectation) for end user=
s.

And another thing is, I can definitely create a local branch with this
fixed to test against fixed autodefrag code, but that won't make much sens=
e.

Thus getting this merged could provide a more realistic baseline for
autodefrag.


Finally, one lesssen I learnt from the defrag thing is, if we allow some
untested/undefined corner cases, it will bite us eventually.

So I really want autodefrag to behave just like ioctl defrag, with a
pre-defined and predictable (at least not under races) behavior.

Thanks,
Qu
