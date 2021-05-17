Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179AD383244
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbhEQOqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241273AbhEQOoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 10:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W+CnPxJauSUM82R6oN864DZXrMAXTzC0WaLq8goFE8I=;
        b=YYIo50ae49VfrvvV5w2IkYNYGdQAUsxPQ64guafZX+LPtVWcGiNbi1+LI9zaobeMNSuEWV
        5dsdFBoxJWgdb1Xb+bE8uLB1u8JuT5e/oOhW0kuXKFAAGQLC3fIa9e0Vpj2ooszJsOasmc
        sTqWVkwJ9ppwrnL6x0nPoEvTzflKsiM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-e5ATTUEWP0mhaxHr42G9nw-1; Mon, 17 May 2021 10:42:54 -0400
X-MC-Unique: e5ATTUEWP0mhaxHr42G9nw-1
Received: by mail-wm1-f69.google.com with SMTP id w7-20020a1cdf070000b02901698cfc1c04so502712wmg.6
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+CnPxJauSUM82R6oN864DZXrMAXTzC0WaLq8goFE8I=;
        b=LUgbb4ON5bhbcWcaXicqWhCxU6ddfh0LKFWe8hgyem/L3/hSUHaKirSaD6tm6uwMOk
         kUKY7BMbsHFgd+nUY9Geia/odiU2GQevmfW8m7GcbL5C1rwrRuIRIykqN5waXhgHcQqu
         yDVXSAQPRTA3L1K4j+3XLuM3qT4M7bO7jXpSzRnrBmfKCLo2TytKaqHJTDDWdN5kEmcx
         a59u2x7scepXxPauLPgK9XuFxj1tewRd7y+RNTdoWby5PplcMRHqWlW1fRYE7LWZ7uwt
         2vDHLWKpUPX3KaCVj2AlWouRGf6VXIYeRgh8enuPGt78L5QhV8k8Ps3vMy4mCOhJ+7j7
         1aug==
X-Gm-Message-State: AOAM5303uYuweyqTSQVB4GOzqAquBVYgKvmJVlFWUUmPrjsRQy6MSCKS
        l2EhCEgmeiw/8sojGUFNlNZwBBTtA2Rz7PCwCqqywds0potSZ73hGVoQj01zKoepmauSniHLRVq
        KGfPysMZ4e4VBPXcshSIvKJewikyT5zIS
X-Received: by 2002:a7b:c012:: with SMTP id c18mr310796wmb.94.1621262572626;
        Mon, 17 May 2021 07:42:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHcIEFrNu6LuUwkN0rauQHwql9CSVQaKUCrKhbCMGPeOCMEPCbU+u/dfSMIehtc+DSIm+gSmQznRWZQM7z+Uo=
X-Received: by 2002:a7b:c012:: with SMTP id c18mr310766wmb.94.1621262572257;
 Mon, 17 May 2021 07:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210429102828.31248-1-prasanna.kalever@redhat.com> <a1c36274-954f-198e-d221-ea4d092aee6e@redhat.com>
In-Reply-To: <a1c36274-954f-198e-d221-ea4d092aee6e@redhat.com>
From:   Prasanna Kalever <pkalever@redhat.com>
Date:   Mon, 17 May 2021 20:12:41 +0530
Message-ID: <CANwsLLHcwp0vhPPWeVEXs_AgJnGYkswBVL3hSm-Z_M630vXsSQ@mail.gmail.com>
Subject: Re: [PATCH] nbd: provide a way for userspace processes to identify
 device backends
To:     josef@toxicpanda.com, axboe@kernel.dk,
        Ming Lei <ming.lei@redhat.com>
Cc:     Prasanna Kumar Kalever <prasanna.kalever@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        nbd@other.debian.org, Ilya Dryomov <idryomov@redhat.com>,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 7:44 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2021/4/29 18:28, Prasanna Kumar Kalever wrote:
> > Problem:
> > On reconfigure of device, there is no way to defend if the backend
> > storage is matching with the initial backend storage.
> >
> > Say, if an initial connect request for backend "pool1/image1" got
> > mapped to /dev/nbd0 and the userspace process is terminated. A next
> > reconfigure request within NBD_ATTR_DEAD_CONN_TIMEOUT is allowed to
> > use /dev/nbd0 for a different backend "pool1/image2"
> >
> > For example, an operation like below could be dangerous:
> >
> > $ sudo rbd-nbd map --try-netlink rbd-pool/ext4-image
> > /dev/nbd0
> > $ sudo blkid /dev/nbd0
> > /dev/nbd0: UUID="bfc444b4-64b1-418f-8b36-6e0d170cfc04" TYPE="ext4"
> > $ sudo pkill -9 rbd-nbd
> > $ sudo rbd-nbd attach --try-netlink --device /dev/nbd0 rbd-pool/xfs-image
> > /dev/nbd0
> > $ sudo blkid /dev/nbd0
> > /dev/nbd0: UUID="d29bf343-6570-4069-a9ea-2fa156ced908" TYPE="xfs"
> >
> > Solution:
> > Provide a way for userspace processes to keep some metadata to identify
> > between the device and the backend, so that when a reconfigure request is
> > made, we can compare and avoid such dangerous operations.
> >
> > With this solution, as part of the initial connect request, backend
> > path can be stored in the sysfs per device config, so that on a reconfigure
> > request it's easy to check if the backend path matches with the initial
> > connect backend path.
> >
> > Please note, ioctl interface to nbd will not have these changes, as there
> > won't be any reconfigure.
> >
> > Signed-off-by: Prasanna Kumar Kalever <prasanna.kalever@redhat.com>
> > ---
> >   drivers/block/nbd.c              | 60 +++++++++++++++++++++++++++++++-
> >   include/uapi/linux/nbd-netlink.h |  1 +
> >   2 files changed, 60 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> > index 4ff71b579cfc..b5022187ad9c 100644
> > --- a/drivers/block/nbd.c
> > +++ b/drivers/block/nbd.c
> > @@ -79,6 +79,7 @@ struct link_dead_args {
> >   #define NBD_RT_HAS_CONFIG_REF               4
> >   #define NBD_RT_BOUND                        5
> >   #define NBD_RT_DISCONNECT_ON_CLOSE  6
> > +#define NBD_RT_HAS_BACKEND_FILE              7
> >
> >   #define NBD_DESTROY_ON_DISCONNECT   0
> >   #define NBD_DISCONNECT_REQUESTED    1
> > @@ -119,6 +120,8 @@ struct nbd_device {
> >
> >       struct completion *destroy_complete;
> >       unsigned long flags;
> > +
> > +     char *backend;
> >   };
> >
> >   #define NBD_CMD_REQUEUED    1
> > @@ -216,6 +219,20 @@ static const struct device_attribute pid_attr = {
> >       .show = pid_show,
> >   };
> >
> > +static ssize_t backend_show(struct device *dev,
> > +             struct device_attribute *attr, char *buf)
> > +{
> > +     struct gendisk *disk = dev_to_disk(dev);
> > +     struct nbd_device *nbd = (struct nbd_device *)disk->private_data;
> > +
> > +     return sprintf(buf, "%s\n", nbd->backend ?: "");
> > +}
> > +
> > +static const struct device_attribute backend_attr = {
> > +     .attr = { .name = "backend", .mode = 0444},
> > +     .show = backend_show,
> > +};
> > +
> >   static void nbd_dev_remove(struct nbd_device *nbd)
> >   {
> >       struct gendisk *disk = nbd->disk;
> > @@ -1215,6 +1232,12 @@ static void nbd_config_put(struct nbd_device *nbd)
> >                                      &config->runtime_flags))
> >                       device_remove_file(disk_to_dev(nbd->disk), &pid_attr);
> >               nbd->task_recv = NULL;
> > +             if (test_and_clear_bit(NBD_RT_HAS_BACKEND_FILE,
> > +                                    &config->runtime_flags)) {
> > +                     device_remove_file(disk_to_dev(nbd->disk), &backend_attr);
> > +                     kfree(nbd->backend);
> > +                     nbd->backend = NULL;
> > +             }
> >               nbd_clear_sock(nbd);
> >               if (config->num_connections) {
> >                       int i;
> > @@ -1274,7 +1297,7 @@ static int nbd_start_device(struct nbd_device *nbd)
> >
> >       error = device_create_file(disk_to_dev(nbd->disk), &pid_attr);
> >       if (error) {
> > -             dev_err(disk_to_dev(nbd->disk), "device_create_file failed!\n");
> > +             dev_err(disk_to_dev(nbd->disk), "device_create_file failed for pid!\n");
> >               return error;
> >       }
> >       set_bit(NBD_RT_HAS_PID_FILE, &config->runtime_flags);
> > @@ -1681,6 +1704,7 @@ static int nbd_dev_add(int index)
> >               BLK_MQ_F_BLOCKING;
> >       nbd->tag_set.driver_data = nbd;
> >       nbd->destroy_complete = NULL;
> > +     nbd->backend = NULL;
> >
> >       err = blk_mq_alloc_tag_set(&nbd->tag_set);
> >       if (err)
> > @@ -1754,6 +1778,7 @@ static const struct nla_policy nbd_attr_policy[NBD_ATTR_MAX + 1] = {
> >       [NBD_ATTR_SOCKETS]              =       { .type = NLA_NESTED},
> >       [NBD_ATTR_DEAD_CONN_TIMEOUT]    =       { .type = NLA_U64 },
> >       [NBD_ATTR_DEVICE_LIST]          =       { .type = NLA_NESTED},
> > +     [NBD_ATTR_BACKEND_IDENTIFIER]   =       { .type = NLA_STRING},
> >   };
> >
> >   static const struct nla_policy nbd_sock_policy[NBD_SOCK_MAX + 1] = {
> > @@ -1956,6 +1981,23 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
> >               }
> >       }
> >       ret = nbd_start_device(nbd);
> > +     if (ret)
> > +             goto out;
> > +     if (info->attrs[NBD_ATTR_BACKEND_IDENTIFIER]) {
> > +             nbd->backend = nla_strdup(info->attrs[NBD_ATTR_BACKEND_IDENTIFIER],
> > +                                       GFP_KERNEL);
> > +             if (!nbd->backend) {
> > +                     ret = -ENOMEM;
> > +                     goto out;
> > +             }
> > +     }
> > +     ret = device_create_file(disk_to_dev(nbd->disk), &backend_attr);
> > +     if (ret) {
> > +             dev_err(disk_to_dev(nbd->disk),
> > +                     "device_create_file failed for backend!\n");
> > +             goto out;
> > +     }
> > +     set_bit(NBD_RT_HAS_BACKEND_FILE, &config->runtime_flags);
> >   out:
> >       mutex_unlock(&nbd->config_lock);
> >       if (!ret) {
> > @@ -2048,6 +2090,22 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
> >                      index);
> >               return -EINVAL;
> >       }
> > +     if (nbd->backend) {
> > +             if (info->attrs[NBD_ATTR_BACKEND_IDENTIFIER]) {
> > +                     if (nla_strcmp(info->attrs[NBD_ATTR_BACKEND_IDENTIFIER],
> > +                                    nbd->backend)) {
> > +                             mutex_unlock(&nbd_index_mutex);
> > +                             dev_err(nbd_to_dev(nbd),
> > +                                     "backend image doesn't match with %s\n",
> > +                                     nbd->backend);
> > +                             return -EINVAL;
> > +                     }
> > +             } else {
> > +                     mutex_unlock(&nbd_index_mutex);
> > +                     dev_err(nbd_to_dev(nbd), "must specify backend\n");
> > +                     return -EINVAL;
> > +             }
> > +     }
> >       if (!refcount_inc_not_zero(&nbd->refs)) {
> >               mutex_unlock(&nbd_index_mutex);
> >               printk(KERN_ERR "nbd: device at index %d is going down\n",
> > diff --git a/include/uapi/linux/nbd-netlink.h b/include/uapi/linux/nbd-netlink.h
> > index c5d0ef7aa7d5..2d0b90964227 100644
> > --- a/include/uapi/linux/nbd-netlink.h
> > +++ b/include/uapi/linux/nbd-netlink.h
> > @@ -35,6 +35,7 @@ enum {
> >       NBD_ATTR_SOCKETS,
> >       NBD_ATTR_DEAD_CONN_TIMEOUT,
> >       NBD_ATTR_DEVICE_LIST,
> > +     NBD_ATTR_BACKEND_IDENTIFIER,
> >       __NBD_ATTR_MAX,
> >   };
> >   #define NBD_ATTR_MAX (__NBD_ATTR_MAX - 1)
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thank you Xiubo Li.

Assuming this patch got lost, attempting to bring this patch onto the
top with a friendly reminder.
I sincerely request the maintainers to please take a look.

Many Thanks!
--
Prasanna

