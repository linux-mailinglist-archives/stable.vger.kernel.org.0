Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDAB2C928B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 00:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388651AbgK3Xae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 18:30:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388590AbgK3Xae (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 18:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606778947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qwePAjO+JoQzIGjZm9jsWctF8D99Rx1DaGUaPJ9flqY=;
        b=aQLFcMZBjLa33rQjAKTCKqNzqF8A1d4bT2jLk03093nSr9kJiFwS3ySACFYJK/OnUyW5i+
        fjCuDEOQ20SXARwrbWEy+wyc0sWdYgzWDr7bPZwSRbWTLWuAtZhS86JvOIubi9MZ1dOR06
        xpVV22LRtBemARZ0EXi2dYnbBmcTIo4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-1tOLfCszM36koXrxwGsY8A-1; Mon, 30 Nov 2020 18:29:01 -0500
X-MC-Unique: 1tOLfCszM36koXrxwGsY8A-1
Received: by mail-wm1-f72.google.com with SMTP id a134so66821wmd.8
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 15:29:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qwePAjO+JoQzIGjZm9jsWctF8D99Rx1DaGUaPJ9flqY=;
        b=gIdHZMSiJJmegnnLAYkVulqKCjOdxKEB083s+Lt44E5B68FTOdTSGsvY5tioRvmfwg
         T0zprPtAM7fDL0bYx/igRULWrNTqQptJjqGJcKRtYvQyXn0Fkiy/2h+8TZwwl6wvwKTo
         l1+8L6kWb9tosjzLTZybLvUj7JisPOSE6TAxpW0W6ohPiPrCkgv/QYFvJuWpL7ktoL3y
         GjJDnnFlPrVATlCLVx4dpA9MrfDa5WHXui7jSQlb7tVL641hg3nOBW9nPeyvO8VUZfeE
         4TCeZSAumdG1CZ8WqiySSPMF7T2Ir8D3pO4rzj3nUdghS3B0wme6pLf/imxxMgzn3idx
         qSrw==
X-Gm-Message-State: AOAM533o25PW02403Y2NZ7GAcbpln9HG0bQhmSMGQGXHnHvcmfn1Ayco
        rb0aMxfrkc0KFr6GV2J3oeKfe72Bd3AkGeVUbrnLv0oi1JFmKiJ8nrGqtmCPw/Nf7WhRNKhi/Ty
        HxG0TS4lnJZLFblfZ1fO9w1oBCuFuBCCa
X-Received: by 2002:a1c:810c:: with SMTP id c12mr201881wmd.96.1606778939763;
        Mon, 30 Nov 2020 15:28:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDplTRUudFfAcqGGcEB/r3VSa3uZ3cetM8uY3SP7Vp30Fs+7Sae/U97WuD9sQ0BTHG5vGW41xQ6vEzZCiStqw=
X-Received: by 2002:a1c:810c:: with SMTP id c12mr201871wmd.96.1606778939628;
 Mon, 30 Nov 2020 15:28:59 -0800 (PST)
MIME-Version: 1.0
References: <20201130194422.741935-1-agruenba@redhat.com>
In-Reply-To: <20201130194422.741935-1-agruenba@redhat.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 1 Dec 2020 00:28:48 +0100
Message-ID: <CAHc6FU7zCJmmMXsAzpg1=f8xM68QrH6hV747JYaT8r2tMrKQQA@mail.gmail.com>
Subject: Re: [PATCH] gfs2: Fix deadlock between gfs2_create_inode and delete_work_func
To:     cluster-devel <cluster-devel@redhat.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 8:44 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> In gfs2_create_inode, make sure to cancel any pending delete work before
> locking the inode glock.  Otherwise, gfs2_cancel_delete_work may block
> waiting for delete_work_func to complete, and delete_work_func may block
> trying to acquire the inode glock in gfs2_inode_lookup.

(Please see version 2 of this patch.)

Thanks,
Andreas

