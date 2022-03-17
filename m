Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABACE4DCF7B
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 21:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiCQUkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 16:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiCQUkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 16:40:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4BCBB917;
        Thu, 17 Mar 2022 13:38:55 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t14so3550527pgr.3;
        Thu, 17 Mar 2022 13:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XXPxc8xF2CJlGObdw/eC6baiwA/XpPKEd/Jy1SJ3ol8=;
        b=N4ZQLI8tGuL3HO7LWthMx63lUi8bBwKx4ejXuWr+Hzv7vwlGzlxOUjoKPnvOZtq6LC
         31S3SSnT23US3dSeCl6I85ttzhDYlywg0PL1/sUs2kkuMe2MyUurbXzOrpAxeVqZ8lQc
         cnLaBIH8VKhUDUqZhHwYk1sh0Nrx1leIl+rjGh1uYlbRS0RVXSiQf88LVt1YKLteXs1t
         kIVkVDOgTu/Zn6yPssRCO23eCMwYwz0NSeZYOxu5OoUPZWgtmVKovnId9+FtBfkCe0Fs
         FjQxP05od8Q1gogWspX2xQ1vEgZ8DXY9+9/oMckgpGGK8kBLYpi0NDX9/yle3+1Ci1p9
         XmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XXPxc8xF2CJlGObdw/eC6baiwA/XpPKEd/Jy1SJ3ol8=;
        b=wckDgOy+TXQ3cNd/MG7qiqW/YvYLp8XEnwOCsoLJ2g57FukOzzUy3leqF93AOTuV1A
         8sRjpCNf4zwBQRPCjyq1qSYEzBKz+C3uqmrw1y3UPXddcQ1Hmt/hDXpvgh5zzfM8N8Hk
         +CE0/FBHNJH+dNlKr3QVCN46LhFk/UOwpLPUdsClNM7o3ZtlyMS/A30rvoIosM7dL4DP
         q9buC1csOEsFDAlHlMU6/in3c8ntAopFnW4YjpIaOs1+TuTDh/yWK/JillL+sKq3K2Kn
         cfUqLq3x8ialiW4f2Y9ifGnkgmv9Ai87VcK9bCZLtKqlUc2gY0cDQBTUzZUpUCzGY/gI
         +seA==
X-Gm-Message-State: AOAM531/XQT4NbZjapcQvmE7LZTPKzyrvlf1zivayiImS8CqKYhpDG0y
        twVmQOki8Fy6vhbzBi6D/a8=
X-Google-Smtp-Source: ABdhPJyK0tJFmlDmVUuHFtogfArqh+PaJZQTl6s/30PTRARFfwstTpt/Vf5VhxkHqx+dRGRiPhVYhg==
X-Received: by 2002:aa7:92cf:0:b0:4fa:3b47:7408 with SMTP id k15-20020aa792cf000000b004fa3b477408mr5232524pfa.72.1647549535202;
        Thu, 17 Mar 2022 13:38:55 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm7673990pfx.34.2022.03.17.13.38.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Mar 2022 13:38:54 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAJuCfpGBJev_h92S0xLEQXghGQzNPCsqWTunpVPJQX4WWPjGzw@mail.gmail.com>
Date:   Thu, 17 Mar 2022 13:38:52 -0700
Cc:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?utf-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B49F17E4-8D3D-45FB-97E9-E0F906C88564@gmail.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
 <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
 <YjNhvhb7l2i9WTfF@google.com>
 <CAJuCfpGBJev_h92S0xLEQXghGQzNPCsqWTunpVPJQX4WWPjGzw@mail.gmail.com>
To:     Suren Baghdasaryan <surenb@google.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Mar 17, 2022, at 9:53 AM, Suren Baghdasaryan <surenb@google.com> =
wrote:
>=20
> On Thu, Mar 17, 2022 at 9:28 AM Minchan Kim <minchan@kernel.org> =
wrote:
>>=20
>> On Wed, Mar 16, 2022 at 02:29:06PM -0700, Andrew Morton wrote:
>>> On Wed, 16 Mar 2022 19:49:38 +0530 Charan Teja Kalla =
<quic_charante@quicinc.com> wrote:
>>>=20
>>>>> IMO, it's worth to note in man page.
>>>>>=20
>>>>=20
>>>> Or the current patch for just ENOMEM is sufficient here and we just =
have
>>>> to update the man page?
>>>=20
>>> I think the "On success, process_madvise() returns the number of =
bytes
>>> advised" behaviour sounds useful.  But madvise() doesn't do that.
>>>=20
>>> RETURN VALUE
>>>       On  success, madvise() returns zero.  On error, it returns -1 =
and errno
>>>       is set to indicate the error.
>>>=20
>>> So why is it desirable in the case of process_madvise()?
>>=20
>> Since process_madvise deal with multiple ranges and could fail at one =
of
>> them in the middle or pocessing, people could decide where the call
>> failed and then make a strategy whether they will abort at the point =
or
>> continue to hint next addresses. Here, problem of the strategy is API
>> doesn't return any error vaule if it has processed any bytes so they
>> would have limitation to decide a policy. That's the limitation for
>> every vector IO syscalls, unfortunately.
>>=20
>>>=20
>>>=20
>>>=20
>>> And why was process_madvise() designed this way?   Or was it
>>> always simply an error in the manpage?
>=20
> Taking a closer look, indeed manpage seems to be wrong.
> https://elixir.bootlin.com/linux/v5.17-rc8/source/mm/madvise.c#L1154
> indicates that in the presence of unmapped holes madvise will skip
> them but will return ENOMEM and that's what process_madvise is
> ultimately returning in this case. So, the manpage claim of "This
> return value may be less than the total number of requested bytes, if
> an error occurred after some iovec elements were already processed."
> does not reflect the reality in our case because the return value will
> be -ENOMEM. After the desired behavior is finalized I'll modify the
> manpage accordingly.

Since process_madvise() might be used in sort of non-cooperative mode,
I think that the caller cannot guarantee that it knows exactly the
memory layout of the process whose memory it madvise=E2=80=99s. I know =
that
MADV_DONTNEED for instance is not supported (at least today) by
process_madvise(), but if it were, the caller may want which exact
memory was madvise'd even if the target process ran some other
memory layout changing syscalls (e.g., munmap()).

IOW, skipping holes and just returning the total number of madvise=E2=80=99=
d
bytes might not be enough.

