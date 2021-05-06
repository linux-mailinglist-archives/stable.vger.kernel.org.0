Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC1F3755D8
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 16:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhEFOql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 10:46:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234759AbhEFOqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 10:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620312341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXu9bu121WPRtwXFS5O/+/gh8Ts+WxkI31oJKaqGVog=;
        b=gZYTsUaHcbvDjD24wj4kJYfSYbII7L33ckZeR2cSaix3VMxImVWFBX5sCQPjtUkJh5k2jp
        fA/L0b7xEDt6cjl2R3GIFZVNiQ220F0iMKp8ACDJ1XMarvx/OcH4H6fxLk5f1b11kuhYGy
        DTntcfbTo8SLjH1R6esPkdVundO8zy8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-RvT2Y6JIOhCGqPrYyg_-tw-1; Thu, 06 May 2021 10:45:40 -0400
X-MC-Unique: RvT2Y6JIOhCGqPrYyg_-tw-1
Received: by mail-wm1-f71.google.com with SMTP id b16-20020a7bc2500000b029014587f5376dso2341178wmj.1
        for <stable@vger.kernel.org>; Thu, 06 May 2021 07:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXu9bu121WPRtwXFS5O/+/gh8Ts+WxkI31oJKaqGVog=;
        b=sOro4WOGhZD2ZkjkO0/2qOpan35X7bOhFnbcO2TIFrK154ABSA2NydoOXE/Yhe9guz
         9VSiKzajdlZtDZMgGSdYURu30yDjwiMEvoiHkpXNQEKEj2UWrz/vmMIbgrvr775mqYVN
         D9STy99i5jAQE0hj3R1fhLBllH/uiUacZa/t5oPZAwuz6guIvESQwAdEw0i7n0GRMBNu
         r6SYAsq0rlu6ZM26IvBBgaIxffNi9MWB5wJXFOPad6L7kPmalhPSWlew7tMe9ojybrE9
         A9RNHHsS6WhHNmw4+efDYv3dqZ2tTAX2zzPfp4khAI9HJ7hB+EBEVFv4a1dplY4AgnFO
         1Pgg==
X-Gm-Message-State: AOAM530zoNFzNAnNwRAjl9RDMluqRyKT7IYd3heHaeDP+WKKYV1z68+y
        A3h8vOd46Z45TJMvDYKnILS02ECHRw7qCTTzXtKPVzOJ5r1TyPCORmk8OSBAZbl4zYBQjuQMf2A
        NUnMn4DhqvCDARdLmQs0HRJjOwKN1ldw1
X-Received: by 2002:a5d:53c3:: with SMTP id a3mr5397974wrw.376.1620312339218;
        Thu, 06 May 2021 07:45:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxz1PUFDI0zrflRoJEKBAjJxn30dp9qgK2/gEGle0R+/Id5dtgvx0BRwncB67LNeoUzRoadMshVf52wfFOazEI=
X-Received: by 2002:a5d:53c3:: with SMTP id a3mr5397940wrw.376.1620312338946;
 Thu, 06 May 2021 07:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210506142658.1077906-1-agruenba@redhat.com>
In-Reply-To: <20210506142658.1077906-1-agruenba@redhat.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 6 May 2021 16:45:27 +0200
Message-ID: <CAHc6FU4Wkutsj8Ud-oDnt=4Qu_8Pc5swc0-jx4+N5VP+w9SaPw@mail.gmail.com>
Subject: Re: [PATCH v2] gfs2: Fix mmap + page fault deadlock
To:     fstests <fstests@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 6, 2021 at 4:27 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Commit 20f829999c38 has moved the inode glock taking from gfs2_readpage and
> gfs2_readahead into gfs2_file_read_iter and gfs2_fault.

Oops, sorry for posting this to the wrong list.

Andreas

