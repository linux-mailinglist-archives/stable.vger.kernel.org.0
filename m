Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905BB496F49
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiAWAxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiAWAxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4075C06173B;
        Sat, 22 Jan 2022 16:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3380360F96;
        Sun, 23 Jan 2022 00:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4DEC340E4;
        Sun, 23 Jan 2022 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642899196;
        bh=2rO45VcO77MmY7trJ4yuLgwjKzWeW0oUMf5L9ABlGuk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cZckpGo7K/A7PXOXWqIoG4dwfhdqzO8QhtRN1VAuZwGgFtRR+aig0H8FWEQTqY0X4
         JKCRF4LAbOAey/5h8MyiOBqkJX+oLSMIiekkWe1hj1l2AOht8zpKJ1tWgKXSmNJ8PP
         +WHwMCUTfPKeMn4JbDgWetQ43I/CvuY7HnsVPaE3kSTg9DIT/8TrVOsmewYwfQO9Bs
         Nf01t6JYcJJTeu2XAc6T1vYFYqMRyCExdDeu67nRXIZISdh5J+dskMjq/ULefWXSZH
         9ypDxXn6GOGdMFt5hA/k+GdJKIxHcL9RnrpO2qTlYobQNcj5ehxA1WFhv1q8o+Hz0M
         cDH5fXnEvDAZw==
Received: by mail-yb1-f181.google.com with SMTP id p5so39265307ybd.13;
        Sat, 22 Jan 2022 16:53:16 -0800 (PST)
X-Gm-Message-State: AOAM532ZSB9/WJvBxnJrZINiX6ve9kk7Qd43C/Gy5jgEBpEcakvqJ4uw
        FG5D5Z5RbQPdNlshCNPKX2HlENT++A5iwsI4Lf4=
X-Google-Smtp-Source: ABdhPJwmu1G5kZ/1BMIPUt1f8+1DhQ56EETFtimQz/I0Ahj/DHzEfZe7Hlc/+HeFaiJp0PAmn+8XG5FRSrNA7ZbCUNM=
X-Received: by 2002:a5b:244:: with SMTP id g4mr15585631ybp.507.1642899195624;
 Sat, 22 Jan 2022 16:53:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sat, 22 Jan 2022
 16:53:15 -0800 (PST)
In-Reply-To: <CAH2r5mugHc1wLtmQsnubUEJo_oHwC1W2ywyEnjFi2ePWdRiWiA@mail.gmail.com>
References: <20220122014722.8699-1-linkinjeon@kernel.org> <CAH2r5mugHc1wLtmQsnubUEJo_oHwC1W2ywyEnjFi2ePWdRiWiA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 23 Jan 2022 09:53:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Cb+NqxNXKvFg4nW3mAohxuDeU6tsDgADd=sEMxyGfZg@mail.gmail.com>
Message-ID: <CAKYAXd9Cb+NqxNXKvFg4nW3mAohxuDeU6tsDgADd=sEMxyGfZg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix SMB 3.11 posix extension mount failure
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-01-22 14:00 GMT+09:00, Steve French <smfrench@gmail.com>:
> Looks good.  I tested it and it works.
>
> With this I can see some additional things work e.g. "stat /mnt/file"
> shows the correct mode bits, but the owner and group are reported as
> the default (0) instead of the actual uid/gid
As we discussed on chat, we need to implement code to handle Sids[] in
smb311_posix_qinfo on both ksmbd and cifs.

fattr->cf_uid = cifs_sb->ctx->linux_uid; /* TODO: map uid and gid from SID */
fattr->cf_gid = cifs_sb->ctx->linux_gid;

cifs client doesn't handle Sids[] from server. Instead, cifs client
seems to use uid/gid from mount option. So the uid/gid will appear as
0. And I will also change ksmbd to set uid/gid to Sid in
smb311_posix_qinfo.

Thanks!
>
> On Fri, Jan 21, 2022 at 7:47 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> cifs client set 4 to DataLength of create_posix context, which mean
>> Mode variable of create_posix context is only available. So buffer
>> validation of ksmbd should check only the size of Mode except for
>> the size of Reserved variable.
>>
>> Fixes: 8f77150c15f8 ("ksmbd: add buffer validation for
>> SMB2_CREATE_CONTEXT")
>> Cc: stable@vger.kernel.org # v5.15+
>> Reported-by: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2pdu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 1866c81c5c99..3926ca18dca4 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2688,7 +2688,7 @@ int smb2_open(struct ksmbd_work *work)
>>                                         (struct create_posix *)context;
>>                                 if (le16_to_cpu(context->DataOffset) +
>>                                     le32_to_cpu(context->DataLength) <
>> -                                   sizeof(struct create_posix)) {
>> +                                   sizeof(struct create_posix) - 4) {
>>                                         rc = -EINVAL;
>>                                         goto err_out1;
>>                                 }
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
>
> Steve
>
