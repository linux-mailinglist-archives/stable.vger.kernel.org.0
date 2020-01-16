Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731A713DFD4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPQUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:20:25 -0500
Received: from mail-vs1-f45.google.com ([209.85.217.45]:33201 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAPQUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:20:25 -0500
Received: by mail-vs1-f45.google.com with SMTP id n27so13034299vsa.0
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 08:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=y8fBDU4I9p4YH4vO5ONWDVa4NA/fEu/ZLgdl772NQOE=;
        b=XX1Nkvoq4Yyky1cU8TQ5AwLJk/fgpuOA0enOAQ/cf3c48rsQRYzO59QEywvA7mIi64
         80wjHoXLvDOnLJu0uqii2LfoqcdFU4NBRChMdA35f8/NucyxgL7iM4iXFLb6ajduMq0d
         6eN1845OA36RxgQHtWRsGp7mJ2M2G6r6QHeAL3QFIKOiIMvcOGRxWR7/aB0IZEnLj9/R
         d94AAnbkXjeH1fJ1OYMmu+0Udgz8aHzy5lfHbJ64fQaOFru6mdhCAoLHysZEyGMJ88fT
         +psmJQkLvdHspzmvtXJHhTlGLxvr9m9eIj6G8XmVN/OYbVDKxjXDmSGdAoRy6pHUYsgi
         XOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=y8fBDU4I9p4YH4vO5ONWDVa4NA/fEu/ZLgdl772NQOE=;
        b=N9ygbj/6CexUhKcfH5oWWdcxr2QUdvLkFCu6xsU4W8QZt26kw+xwX9gZd4XAh0LeXc
         B5g/xPmxYpp1rz5IMHvmMo0/f2tE4KpKavjaVGf6j1vKuVkuAVvwoiC+yuG4wu7QfdFW
         AvQH8yk3+UrIOR8zQE2xLG/BtH2JfJjpcfwW0GXaofS4PG1elehlou6QyI4lv/cn/dU0
         +fJ/gMvoSfYXUn1D822NBMmaOTAzocO+IvjzuQbGA3k7vkIofsV9aqp3dPnOXva14yu0
         xN+xc3crPvGoZL9TaU7/jWT946aqcDxyxDkL2oWwInbn7yxiF30YgIr+t7hAZD1ZoyfN
         dvCg==
X-Gm-Message-State: APjAAAXP6nUi6irNkpgc2+yVqimi1rBw1F3s9PA9IamN77/9tF7FkMlP
        IQbYaWmDH5nLBoxBsEjrJDqQXJvZWLK8sxOnvWv3LmfVgNnf7A==
X-Google-Smtp-Source: APXvYqz2IJuQ+rEN9KQrQJENd25eN5gRPy7ZIPu70U0TsMArUMu7wHUK78UfMu2Tf82M3J+2bDX2Tfzt/fpDZ9dJFAQ=
X-Received: by 2002:a05:6102:1173:: with SMTP id k19mr2102556vsg.203.1579191623041;
 Thu, 16 Jan 2020 08:20:23 -0800 (PST)
MIME-Version: 1.0
From:   Alistair Delva <adelva@google.com>
Date:   Thu, 16 Jan 2020 08:20:11 -0800
Message-ID: <CANDihLFwsdpGmR5j++bLSaxGYuXOtykA-B2T0rWiXgzdfCPkJg@mail.gmail.com>
Subject: Please revert "drm/virtio: switch virtio_gpu_wait_ioctl() to gem
 helper." from 5.4-stable
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, Lingfeng Yang <lfy@google.com>,
        kraxel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(Sorry if this is noise and has already been reported)

After updating to 5.4.7 we noticed that virtio_gpu's wait ioctl
stopped working correctly.

It looks like 29cf12394c05 ("drm/virtio: switch
virtio_gpu_wait_ioctl() to gem helper.") was picked up automatically,
but it depends on 889165ad6190 ("drm/virtio: pass gem reservation
object to ttm init") from earlier in Gerd's series in Linus's tree,
which was not picked up.

(This patch doesn't seem like compelling stable material so maybe we
should revert it.)
