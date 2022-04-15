Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10095025F8
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 09:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbiDOHFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 03:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiDOHFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 03:05:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D008B1A9F;
        Fri, 15 Apr 2022 00:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650006166;
        bh=dtAT3rEXGIzFcVqDUogX+eie4QwgphXzhaDg5TRCw6g=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=d2vOVh2DwfP9ZK8p4dP41iTRpgQefakc1Im/Da3iws/KwZtmIHCVgw1H118OWBFdI
         MQ3vvd2TjJEGhIgH0CBLzKDmORInW8KIv0OjwQDsW7/ecX4tceiFy9leUbtOxjH/6g
         PcWLl3+Xnk3DqArImhhxNP2jmKv52yFsAJ1/1APo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MoO6C-1oGnev0d8i-00omGM; Fri, 15
 Apr 2022 09:02:45 +0200
Message-ID: <37226b35-7d5a-dd86-7b20-7a0dfd3b96fc@gmx.com>
Date:   Fri, 15 Apr 2022 15:02:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <YlkQgTCv+Iw2QzPz@infradead.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio()
 failed
In-Reply-To: <YlkQgTCv+Iw2QzPz@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gHOUDqyxySdTTSvAmYN7JKSxDdutshLbBV3fQ9gAmQlAdcYgmAa
 EcvJe9tX8gKOp7etdC/f7ZLf+oavd74pcpWdjrVKXh7ervqfU6F/awMyj7vVOMOCWVG9+fu
 a9D9gXI3iTVo2A/yxI++H/swd4wroU0pSJ1W2PTnRKzux7JAmSepElme+iTk6MPvtJIcP7l
 9aFMu0ijwFcYGWivsFIug==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z1tV8W/LLW0=:KQ+SlmFz5RvUC5kWcUJhsv
 Lstrhg5/1watScFDKbnPh4pPqqGhU3sRlLdV6gKT84oGkxG2j9/E3xybdag2O0EbJ3jSvXSXL
 31OXIvJK2RglR2HBF23ysJZDlOc6pAJNYa0pRpddqLMEHuf+SHhqNK2krxCLgTMfVbOrvjx39
 NVlmr1tspoWUDsfDv1aHamaAxTJ7T8nIsxYN2pA4EIXbt322DKLpJ1GSWPOhfrgrTf+BJHTag
 z5KNkwBmDHbPi6+GDqR6Pb4QdJ4bwzNhvmMDh2hHMrka5OMMtmV4UXzr1BsboKAI/Z22lgTSt
 ZRu84RXeb2s0vL0LF841WGVntg4GUsYCf3nklIDTXU72p+qq0kJgPgEtvSE+Vyac3JZi+y6Cr
 vjyxwt+RU5vAbG17Oc/EyTZEiNKQ/9tUJFUjXjCm5/fk0VR21jJWybyl2XE+bu8LT8jx3bLxr
 4f5iCZAvLc/upXimTYEx81vUaM9h7EEtDfxi4EH9b/oexMf9AP7kdSabm9j/0++QZiZItxcQr
 Y2KE4r9lBTkioyD2W8ByVw5SqQ509ajdShw9ixdW2Vda5iA4O0QqKq9qzAdwiWnElaF9VerWG
 RU1g5MBlN1gx8qGunk0ZsUAO3uPiSc/z9K81HvEYs4erxhT7IwhCBVy3pSRzifsPRoYlnwz0n
 EsSxuWlg9dFqsCqPqN7aG5q0BVMvfBnF2ook6UKCwxWOocYTns2Lhc6b0XJS/EEAihQVMigT8
 hitasu+xIhXPu2NJNkpTtbF2lMpgyl2V6wkP1Dh8zJA2eJifzuOOvJ+vwsIijxPBCPgXJuKgf
 bYursZRevYhaosYsulFZ/lrFu0D+iMlicYepE63RG5KHwfGVa/VtCi8yVGs9bx1zjt6qnNM6a
 taJbJ3wEMcGQv7yfcN/XnCiF20Bx7IlSXL+QhP0PBC5VBhspPfr/gNIN2h1At3UIA/PCMl295
 iGUtFZamfRL01XVIu05ovfXod0cUvNK0gO+CNosZDnOs3pnThCJP3v6xEaYsctEhZxTugUDDG
 uuMMSvW25b5gfPbI1xwZDMVptKENiP//qC/oZYbrLwezIDmItwiGboFZyyXlTyvzKwqdoc2Ve
 hcN7Cl3hMw50jY=
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/15 14:28, Christoph Hellwig wrote:
> Btw, btrfs_submit_compressed_write also seems to do some double cleanups=
,
> even if the pattern is slightly different as the bio is allocated inside
> btrfs_submit_compressed_write itself.  Can someone who is more familiar
> with that code look into that?

I just checked the code, it's indeed causing problems.

If btrfs_csum_one_bio() or submit_compressed_bio() failed (either ENOMEM
or failed some sanity checks), then we have one bio for writing the
compressed data back to disk.

Finish_cb label will call endio on it, which will call:
  -> end_compressed_bio_write()
     -> finish_compressed_bio() (this needs the compressed write bio not
be split)

Then finish_cb tag will also call finish_compressed_bio() directly.
Double freeing cb, and double clearing writeback flags.

The only relief is, regular EIO won't trigger the bug for write path.


But this can not be said to btrfs_submit_compressed_read(), which has
the same problem and can be triggered by EIO error easily.

Do you want to give it a try? Or mind to me fix it?

Thanks,
Qu
