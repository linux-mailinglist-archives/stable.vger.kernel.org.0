Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541FBD4370
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfJKOwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 10:52:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727587AbfJKOwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 10:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570805539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LjOMlr04CDEWM+WiRuQ0QvBbFcIyJJ1BMad1vbnZ+hQ=;
        b=gotuEtQzLIP/EAy9jYlErJX+xJk5QdD3ovjG1fq9p3PbRg426h/6x1iWQ08R2OLP9ONvwW
        b1L083wiU9+yKriVXHND60nNuIIaIcGLCnDTk/Fs5s+B0B+tyhjNLL6uffob8DcOPHbjFJ
        JjLe1uw9L+EP+4SO68nbUdYMQPiYOxs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-fj-vSaevPVKKw38L4RjRSg-1; Fri, 11 Oct 2019 10:52:17 -0400
Received: by mail-qt1-f197.google.com with SMTP id r19so9642972qtk.15
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 07:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZ0bfU2716rhby1DyBXCXfWn03SSsmBdmRdt0EnLS1k=;
        b=n6R2LqeAMW6u32QoujdEzkSPYc7mF+0Uf8zYFff512Pl3I2M+YtF/nSID1BHZt8xn3
         yFr5TcHql2tRo+t0MwbYHfGxiyRMMLLyTQogO8rPciHI8ZQQk61Q8+xRlEonp14PcaVZ
         0jjEI3CR04Op6mO93fueaSVVLrkJWr/DaW0+x1RGFfjNE3/ESr7lbz9d6MPxnFFBcaxh
         Sv5JjKEuXV2Vs/pna7jzhPv+Co8mQhLDgfJ8//jVo616q8sF8sVybQNebPq+aO1u9RgP
         p/zkqXwDIwhrdY/IRijm2TU6P6yFgNJNJCAovS8KrqS2LlYVyhVzu9tDscJLj6TNdjLV
         dyUA==
X-Gm-Message-State: APjAAAVjTxw61V+7DyuVR2Mqib/jSRkxiGlq+UR63dyaFD3AQEzlZ1Y6
        yDOwIdTsmzkrmQrvdR7FQxTzpZ6XqZqvICJb2eNt8o7ecqOZISUCKMt37VYNe5/28bSMNr1Hfd0
        dsckzIUGj7YobniweqOBK5l8OUwGl0EQr
X-Received: by 2002:ae9:f306:: with SMTP id p6mr16072317qkg.169.1570805536485;
        Fri, 11 Oct 2019 07:52:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzTfHCZ3UlZd2fgDUgIL/k7ZBTcdoSj99nnvjVsUswVePU8Cqx6eoHwfnLCLhbgJCWU7048/TDkRczOka2mx9A=
X-Received: by 2002:ae9:f306:: with SMTP id p6mr16072285qkg.169.1570805536178;
 Fri, 11 Oct 2019 07:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com> <20191007051240.4410-2-andrew.smirnov@gmail.com>
In-Reply-To: <20191007051240.4410-2-andrew.smirnov@gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 11 Oct 2019 16:52:04 +0200
Message-ID: <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: fj-vSaevPVKKw38L4RjRSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wr=
ote:
>
> To simplify resource management in commit that follows as well as to
> save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> driver code to use devres to manage the life-cycle of FF private data.
>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: Henrik Rydberg <rydberg@bitmath.org>
> Cc: Sam Bazely <sambazley@fastmail.com>
> Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> Cc: Austin Palmer <austinp@valvesoftware.com>
> Cc: linux-input@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org

This patch doesn't seem to fix any error, is there a reason to send it
to stable? (besides as a dependency of the rest of the series).

> ---
>  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
>  1 file changed, 29 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-=
hidpp.c
> index 0179f7ed77e5..58eb928224e5 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
>         struct hidpp_ff_private_data *data =3D ff->private;
>
>         kfree(data->effect_ids);

Is there any reasons we can not also devm alloc data->effect_ids?

> +       /*
> +        * Set private to NULL to prevent input_ff_destroy() from
> +        * freeing our devres allocated memory

Ouch. There is something wrong here: input_ff_destroy() calls
kfree(ff->private), when the data has not been allocated by
input_ff_create(). This seems to lack a little bit of symmetry.

> +        */
> +       ff->private =3D NULL;
>  }
>
>  static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
> @@ -2090,7 +2095,7 @@ static int hidpp_ff_init(struct hidpp_device *hidpp=
, u8 feature_index)
>         const u16 bcdDevice =3D le16_to_cpu(udesc->bcdDevice);
>         struct ff_device *ff;
>         struct hidpp_report response;
> -       struct hidpp_ff_private_data *data;
> +       struct hidpp_ff_private_data *data =3D hidpp->private_data;
>         int error, j, num_slots;
>         u8 version;
>
> @@ -2129,18 +2134,13 @@ static int hidpp_ff_init(struct hidpp_device *hid=
pp, u8 feature_index)
>                 return error;
>         }
>
> -       data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> -       if (!data)
> -               return -ENOMEM;
>         data->effect_ids =3D kcalloc(num_slots, sizeof(int), GFP_KERNEL);
> -       if (!data->effect_ids) {
> -               kfree(data);
> +       if (!data->effect_ids)
>                 return -ENOMEM;
> -       }
> +
>         data->wq =3D create_singlethread_workqueue("hidpp-ff-sendqueue");
>         if (!data->wq) {
>                 kfree(data->effect_ids);
> -               kfree(data);
>                 return -ENOMEM;
>         }
>
> @@ -2199,28 +2199,15 @@ static int hidpp_ff_init(struct hidpp_device *hid=
pp, u8 feature_index)
>         return 0;
>  }
>
> -static int hidpp_ff_deinit(struct hid_device *hid)
> +static void hidpp_ff_deinit(struct hid_device *hid)
>  {
> -       struct hid_input *hidinput =3D list_entry(hid->inputs.next, struc=
t hid_input, list);
> -       struct input_dev *dev =3D hidinput->input;
> -       struct hidpp_ff_private_data *data;
> -
> -       if (!dev) {
> -               hid_err(hid, "Struct input_dev not found!\n");
> -               return -EINVAL;
> -       }
> +       struct hidpp_device *hidpp =3D hid_get_drvdata(hid);
> +       struct hidpp_ff_private_data *data =3D hidpp->private_data;
>
>         hid_info(hid, "Unloading HID++ force feedback.\n");
> -       data =3D dev->ff->private;
> -       if (!data) {

I am pretty sure we might need to keep a test on data not being null.

> -               hid_err(hid, "Private data not found!\n");
> -               return -EINVAL;
> -       }
>
>         destroy_workqueue(data->wq);
>         device_remove_file(&hid->dev, &dev_attr_range);
> -
> -       return 0;
>  }

This whole hunk seems unrelated to the devm change.
Can you extract a patch that just stores hidpp_ff_private_data in
hidpp->private_data and then cleans up hidpp_ff_deinit() before
switching it to devm? (or maybe not, see below)

After a few more thoughts, I don't think this mixing of devm and non
devm is a good idea:
we could say that the hidpp_ff_private_data and its effect_ids are
both children of the input_dev, not the hid_device. And we would
expect the whole thing to simplify with devm, but it's not, because ff
is not supposed to be used with devm.

I have a feeling the whole ff logic is wrong in term of where things
should be cleaned up, but I can not come up with a good hint on where
to start. For example, destroy_workqueue() is called in
hidpp_ff_deinit() where it might be racy, and maybe we should call it
in hidpp_ff_destroy()...

Last, you should base this patch on top of the for-next branch, we
recently merged a fix for the FF drivers in the HID subsystem:
https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/commit/?h=3Dfor=
-next&id=3Dd9d4b1e46d9543a82c23f6df03f4ad697dab361b

Would it be too complex to drop this patch from the series and do a
proper follow up cleanup series that might not need to go to stable?

Cheers,
Benjamin

>
>
> @@ -2725,6 +2712,20 @@ static int k400_connect(struct hid_device *hdev, b=
ool connected)
>
>  #define HIDPP_PAGE_G920_FORCE_FEEDBACK                 0x8123
>
> +static int g920_allocate(struct hid_device *hdev)
> +{
> +       struct hidpp_device *hidpp =3D hid_get_drvdata(hdev);
> +       struct hidpp_ff_private_data *data;
> +
> +       data =3D devm_kzalloc(&hdev->dev, sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       hidpp->private_data =3D data;
> +
> +       return 0;
> +}
> +
>  static int g920_get_config(struct hidpp_device *hidpp)
>  {
>         u8 feature_type;
> @@ -3561,6 +3562,10 @@ static int hidpp_probe(struct hid_device *hdev, co=
nst struct hid_device_id *id)
>                 ret =3D k400_allocate(hdev);
>                 if (ret)
>                         return ret;
> +       } else if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
> +               ret =3D g920_allocate(hdev);
> +               if (ret)
> +                       return ret;
>         }
>
>         INIT_WORK(&hidpp->work, delayed_work_cb);
> --
> 2.21.0
>

