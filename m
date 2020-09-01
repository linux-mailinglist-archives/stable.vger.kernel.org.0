Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F6F258FFC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgIAONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:13:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728224AbgIAONf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 10:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598969605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmiElt+9vhSWgn5IQs4zZ1hI4HFHW1dobLkb12hq7e0=;
        b=Z1duOMO5KjvjpIT+NNVTw2aNPVBhY8rKE2UYHyfz8l9LXkqHSs9rcy/mQXfA4Bxl3dMQCC
        q4WyonJ2GS+kmzWJvmrS4EqDNF//pSccPj8hEu9DlsyQglbbbBwGqeD8qC3q5ig5oYZBE2
        Sae5VVc1vMp3H81xO0qpg3xyYa3JtxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-9b_WghmtOdeIBcwk43FnZQ-1; Tue, 01 Sep 2020 10:11:18 -0400
X-MC-Unique: 9b_WghmtOdeIBcwk43FnZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7034618CBC40
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 14:11:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68DD67C5A0
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 14:11:17 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61E827A2E3;
        Tue,  1 Sep 2020 14:11:17 +0000 (UTC)
Date:   Tue, 1 Sep 2020 10:11:17 -0400 (EDT)
From:   Bob Peterson <rpeterso@redhat.com>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org
Message-ID: <1627290349.15019228.1598969477058.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200829092656.1173430-1-agruenba@redhat.com>
References: <20200829092656.1173430-1-agruenba@redhat.com>
Subject: Re: [Cluster-devel] [PATCH] gfs2: Make sure we don't miss any
 delayed        withdraws
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.112.23, 10.4.195.29]
Thread-Topic: gfs2: Make sure we don't miss any delayed withdraws
Thread-Index: VoLo+U/TkLWMztf9VlU2T0Q+oPJTBw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Original Message -----
> Commit ca399c96e96e changes gfs2_log_flush to not withdraw the
> filesystem while holding the log flush lock, but it fails to check if
> the filesystem needs to be withdrawn once the log flush lock has been
> released.  Likewise, commit f05b86db314d depends on gfs2_log_flush to
> trigger for delayed withdraws.  Add that and clean up the code flow
> somewhat.
> 
> In gfs2_put_super, add a check for delayed withdraws that have been
> missed to prevent these kinds of bugs in the future.
> 
> Fixes: ca399c96e96e ("gfs2: flesh out delayed withdraw for gfs2_log_flush")
> Fixes: f05b86db314d ("gfs2: Prepare to withdraw as soon as an IO error occurs
> in log write")
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
Looks good.

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

Bob Peterson

