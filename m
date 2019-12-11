Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0111AA5A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 12:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfLKL7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 06:59:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727469AbfLKL7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 06:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576065549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MJ/fwuQR4t72zOTPK9wMDKlEy/poZs/KypX6iUojPE=;
        b=JZzVHciHJAt5G6x+LU+6oP4j2q6BkuzJOPJ6tMfsZ6XXSPG85iZASJ084jFw/8ClxIEXtj
        SPsjP/Rqq0/6pecRm3AVNK0wQoDr8JnIL8GCql8Br8UApPLMz5+zCBEc4R6DNFh0jYfWe0
        GJ3e5wV4rghe92fqA0OKGbAOq3jDU0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-2FEyLIKVOxWoD7oWFM6o2w-1; Wed, 11 Dec 2019 06:59:08 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFBF718552A1;
        Wed, 11 Dec 2019 11:59:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E168263BCE;
        Wed, 11 Dec 2019 11:59:06 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D105083701;
        Wed, 11 Dec 2019 11:59:06 +0000 (UTC)
Date:   Wed, 11 Dec 2019 06:59:06 -0500 (EST)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Message-ID: <1494038413.477288.1576065546815.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191210113737.4016-5-johan@kernel.org>
References: <20191210113737.4016-1-johan@kernel.org> <20191210113737.4016-5-johan@kernel.org>
Subject: Re: [PATCH 4/7] Input: gtco: fix endpoint sanity check
MIME-Version: 1.0
X-Originating-IP: [10.40.205.203, 10.4.195.10]
Thread-Topic: Input: gtco: fix endpoint sanity check
Thread-Index: 3V9+GHLYaSjQ6iE6ppPbHQZjaM9agA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 2FEyLIKVOxWoD7oWFM6o2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, Johan! A fix for a bug indeed.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Johan Hovold" <johan@kernel.org>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, "Johan Hovold"
> <johan@kernel.org>, "stable" <stable@vger.kernel.org>, "Vladis Dronov" <vdronov@redhat.com>
> Sent: Tuesday, December 10, 2019 12:37:34 PM
> Subject: [PATCH 4/7] Input: gtco: fix endpoint sanity check
> 
> The driver was checking the number of endpoints of the first alternate
> setting instead of the current one, something which could lead to the
> driver binding to an invalid interface.
> 
> This in turn could cause the driver to misbehave or trigger a WARN() in
> usb_submit_urb() that kernels with panic_on_warn set would choke on.
> 
> Fixes: 162f98dea487 ("Input: gtco - fix crash on detecting device without
> endpoints")
> Cc: stable <stable@vger.kernel.org>     # 4.6
> Cc: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

