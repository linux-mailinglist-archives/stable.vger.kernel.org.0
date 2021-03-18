Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85A340069
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 08:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhCRHsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 03:48:25 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:49985 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhCRHsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 03:48:23 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id MnOElHpsdDUxpMnOHli1ki; Thu, 18 Mar 2021 08:48:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1616053701; bh=5C1FiCQtJnCi35+zulo1I+KdekoC7l6UN2flOZzlD8s=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=RHXq026zaRBDPilb7B9PsTTNvNiyMjrsTz2IVlxr+0iVqOJZWifK8n3wELzTkwXdm
         qLrTOkSrzJ2xso/dlL2dx478i8LIGkOo0tLjMGlxfNfzJqC7bUrJTwsOUoBACUN9ew
         LmKjHR85UL8U5u+40aCzQpKBDjH9bovj7hWg0q/DjFDFGe1DG8sCcsJ8Y5DfXb+tj/
         weKLf43lTPsrittDB+aWQu8mgKugx6tbUqx+FkhegKJgT8GZMabTBFhFvxDiW48RjT
         PZVMN5NKIEvGxulmu1OVVp+C/wtv9eU4q7ZC7TswwIaFS6vZdAWDIMMABDDvkrJBys
         5vUE9uPQgexQQ==
Subject: Re: [PATCH v6 01/17] media: v4l2-ioctl: check_ext_ctrls: Fix
 multiclass V4L2_CTRL_WHICH_DEF_VAL
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>, stable@vger.kernel.org
References: <20210317164511.39967-1-ribalda@chromium.org>
 <20210317164511.39967-2-ribalda@chromium.org>
 <f07a5767-fced-18af-8219-6e54b83a785d@xs4all.nl>
 <CANiDSCs+xc-nMksdZVZq4Z3mn=wd8rD14AhXOiup3D95sO50xg@mail.gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <e6273f17-cd0d-7fe5-bfc1-3827c2fbc82e@xs4all.nl>
Date:   Thu, 18 Mar 2021 08:48:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CANiDSCs+xc-nMksdZVZq4Z3mn=wd8rD14AhXOiup3D95sO50xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHdnB7tT5SPw+DvnO0l+g8AEQ5cYkq5cwJXqZlSXBfVHVLrsLhn2KITR1YoEagDFW+rc/Ewkdy1HPLbPOa78TPXZ7aVisg45ndpB0Opdus2w2vsvgsfZ
 +n9z1SCO1PBAHnMboFr/x3NpzbEiqHD/+GmHWKVObyeWpObd9yAET908piHfnoE8r5ybHwnxrGFEVsjFTSl894KvmOOcFuURO1VlKLzKM0jmiz52Mk19bMGa
 X/mBos00yhm5fGeXUJAqB61qGhLHnmi9KU/JJkZ36XFbpK3AxsLR+KZtXko6efgmto7BG3OkH2h11MzzNOEJziGqoLHvqZDrzZLmFIr1Qz9YIlRAvwPLjjEK
 oeSdRf6jztuLpNqt2/KCIZOT30zCq3mgdaimglp1tG3qLDd/cGWLAwOm+n500vLLQnQ6mFSpgjMS4WIwS6aFDQQj+/o5nZfm3ftbXD7dwLk4/PIOBI0=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/03/2021 08:17, Ricardo Ribalda wrote:
> Hi Hans
> 
> Can I merge 1-3, but leave 4 as a separate one? It helps to tell a
> story for 5 and  6.

I really prefer it as a single patch. All four patches are basically a single big fix
for v4l2-ioctl.c where the code for drivers that do not use the control framework had
become very outdated. Fixing it in a single patch helps backporting to stable, and
it is easier to review and see everything that had to be done to fix this.

In this case I wondered when I was reviewing patch 1 why V4L2_CTRL_WHICH_DEF_VAL was
just accepted without checking for S/TRY_EXT_CTRLS. Basically patch 1 is a broken fix
w.r.t. DEF_VAL until patch 4, which really fixes it.

Just do it all in a single patch, splitting it up doesn't work in this particular case.

Regards,

	Hans

> 
> Thanks
> 
> On Thu, Mar 18, 2021 at 8:14 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>>
>> Hi Ricardo,
>>
>> On 17/03/2021 17:44, Ricardo Ribalda wrote:
>>> Drivers that do not use the ctrl-framework use this function instead.
>>>
>>> - Do not check for multiple classes when getting the DEF_VAL.
>>>
>>> Fixes v4l2-compliance:
>>> Control ioctls (Input 0):
>>>               fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
>>>       test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>>
>> Can you merge patches 1-4 into a single patch? It's really one big fix since
>> this code was never updated when new 'which' values were added. So keeping it
>> together is, for once, actually preferred.
>>
>> You can add my:
>>
>> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> after these 4 patches are merged. It looks much nicer now.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
>>> Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 47 ++++++++++++++++------------
>>>  1 file changed, 27 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 31d1342e61e8..403f957a1012 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -908,7 +908,7 @@ static void v4l_print_default(const void *arg, bool write_only)
>>>       pr_cont("driver-specific ioctl\n");
>>>  }
>>>
>>> -static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>>> +static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
>>>  {
>>>       __u32 i;
>>>
>>> @@ -917,23 +917,30 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>>>       for (i = 0; i < c->count; i++)
>>>               c->controls[i].reserved2[0] = 0;
>>>
>>> -     /* V4L2_CID_PRIVATE_BASE cannot be used as control class
>>> -        when using extended controls.
>>> -        Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
>>> -        is it allowed for backwards compatibility.
>>> -      */
>>> -     if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
>>> -             return 0;
>>> -     if (!c->which)
>>> -             return 1;
>>> +     switch (c->which) {
>>> +     case V4L2_CID_PRIVATE_BASE:
>>> +             /*
>>> +              * V4L2_CID_PRIVATE_BASE cannot be used as control class
>>> +              * when using extended controls.
>>> +              * Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
>>> +              * is it allowed for backwards compatibility.
>>> +              */
>>> +             if (ioctl == VIDIOC_G_CTRL || ioctl == VIDIOC_S_CROP)
>>> +                     return false;
>>> +             break;
>>> +     case V4L2_CTRL_WHICH_DEF_VAL:
>>> +     case V4L2_CTRL_WHICH_CUR_VAL:
>>> +             return true;
>>> +     }
>>> +
>>>       /* Check that all controls are from the same control class. */
>>>       for (i = 0; i < c->count; i++) {
>>>               if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
>>>                       c->error_idx = i;
>>> -                     return 0;
>>> +                     return false;
>>>               }
>>>       }
>>> -     return 1;
>>> +     return true;
>>>  }
>>>
>>>  static int check_fmt(struct file *file, enum v4l2_buf_type type)
>>> @@ -2229,7 +2236,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
>>>       ctrls.controls = &ctrl;
>>>       ctrl.id = p->id;
>>>       ctrl.value = p->value;
>>> -     if (check_ext_ctrls(&ctrls, 1)) {
>>> +     if (check_ext_ctrls(&ctrls, VIDIOC_G_CTRL)) {
>>>               int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
>>>
>>>               if (ret == 0)
>>> @@ -2263,7 +2270,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
>>>       ctrls.controls = &ctrl;
>>>       ctrl.id = p->id;
>>>       ctrl.value = p->value;
>>> -     if (check_ext_ctrls(&ctrls, 1))
>>> +     if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
>>>               return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
>>>       return -EINVAL;
>>>  }
>>> @@ -2285,8 +2292,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>>>                                       vfd, vfd->v4l2_dev->mdev, p);
>>>       if (ops->vidioc_g_ext_ctrls == NULL)
>>>               return -ENOTTY;
>>> -     return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
>>> -                                     -EINVAL;
>>> +     return check_ext_ctrls(p, VIDIOC_G_EXT_CTRLS) ?
>>> +                             ops->vidioc_g_ext_ctrls(file, fh, p) : -EINVAL;
>>>  }
>>>
>>>  static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>>> @@ -2306,8 +2313,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>>>                                       vfd, vfd->v4l2_dev->mdev, p);
>>>       if (ops->vidioc_s_ext_ctrls == NULL)
>>>               return -ENOTTY;
>>> -     return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
>>> -                                     -EINVAL;
>>> +     return check_ext_ctrls(p, VIDIOC_S_EXT_CTRLS) ?
>>> +                             ops->vidioc_s_ext_ctrls(file, fh, p) : -EINVAL;
>>>  }
>>>
>>>  static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>>> @@ -2327,8 +2334,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>>>                                         vfd, vfd->v4l2_dev->mdev, p);
>>>       if (ops->vidioc_try_ext_ctrls == NULL)
>>>               return -ENOTTY;
>>> -     return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
>>> -                                     -EINVAL;
>>> +     return check_ext_ctrls(p, VIDIOC_TRY_EXT_CTRLS) ?
>>> +                     ops->vidioc_try_ext_ctrls(file, fh, p) : -EINVAL;
>>>  }
>>>
>>>  /*
>>>
>>
> 
> 

