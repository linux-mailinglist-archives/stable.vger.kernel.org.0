Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF35BD7F8
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 07:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411805AbfIYFyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 01:54:16 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40888 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404361AbfIYFyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 01:54:16 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so10582931iof.7
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 22:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=aDA9O7aHNZyiEP75T11J2tw41bxL3kYdoacbX9gdoz4=;
        b=DZVdCxif1ICM5oteeyVKbg9jBoOo3cYs8jtmCH1NwDAwTf8FrrFnj98GQYbzB1KHWn
         8YogVM/2t39KMtnQFAvULcO/XDaltaSKmdvo9cbYk2v/fxYiWAmLGik6/Zm/FSqrZVHn
         /5eKW/ySS72qzdK0mNvSnjm2utZzeIJI2BTZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aDA9O7aHNZyiEP75T11J2tw41bxL3kYdoacbX9gdoz4=;
        b=inuTncWpauJciRD5XwQ+X2z6AQz7EcobuoxgDoZ47wQfSYGVKyWUrXDT2F3XqjTn6R
         qw6dyuGtYGVuOep6pvOuCGG2FVPyRtO9gJkk9eaK0zVYXqrm+OEvZ+4fmi3klLitL/X/
         dNX460rxwW8b8QrISMvXeGPxGSTSFacslzpNMC27SiTsfWBa7kqQb3Q1iU7LiX8xc9AW
         JES6X4ZFiI5WFb6/2r1hEig7cuo21dglix7W+kL7In/1VI/RcD+f1df8PGkCfk5GFNlF
         roZ0iKEjpgVxzmdbnXP8gU16xKQfNf0rmlpskSCB2cVKh2OraHEmMBIhY1jD4mDw0q1F
         FSyA==
X-Gm-Message-State: APjAAAW8Qb8RSy7TcnMilrBhCYTs59k/hqWoWF7u9Nr8ZolyduKfd0fT
        kH4c2OlZHp6dXNpCLcldkIGqzhJFEgVp8ujh2MTbsSdGPFz1Zw==
X-Google-Smtp-Source: APXvYqwnOS3oLSqo4vnOH8+qW2GWv5GKPWxSU1OZsNNNlo9OQXrZisiIrKE18KpHf74cj7hYOCCpLTSvhXwR2bprynw=
X-Received: by 2002:a02:b782:: with SMTP id f2mr3560407jam.48.1569390853906;
 Tue, 24 Sep 2019 22:54:13 -0700 (PDT)
MIME-Version: 1.0
From:   Dave Chiluk <chiluk+linux@indeed.com>
Date:   Wed, 25 Sep 2019 00:53:48 -0500
Message-ID: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
Subject: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with
 high throttling by removing expiration of cpu-local slices
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
throttling by removing expiration of cpu-local slices") fixes a major
performance issue for containerized clouds such as Kubernetes.

Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
bandwidth timer clock drift condition").

This should be applied to all stable kernels that applied commit
512ac999d275, and should probably be applied to all others as well.

The issues introduced by these pathes can be read about on the
Kubernetes github.
https://github.com/kubernetes/kubernetes/issues/67577

It may also be prudent to also apply the not yet accepted patch that
fixes some introduced compiler warnings discussed here.
https://lkml.org/lkml/2019/9/18/925

Thank you,
Dave Chiluk
