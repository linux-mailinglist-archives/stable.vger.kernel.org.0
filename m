Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA5011AA4F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 12:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfLKLzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 06:55:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48205 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727469AbfLKLzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 06:55:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576065349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XwexMGmPekdr4+AxISaEIBvhb/7gR+zi4pC7R+9p3hQ=;
        b=iCeAOWkjbXZE3Nyxmtu8F47PPrJx0Wk3icxUFLuuduSL5EyUNvemtD5vD5XNW8k8pd6YXx
        M0P9xmiPKaD+QP80iucFfjPX+0hgJjNM1fZMnuFDPGJj30y3ScxZy9rh9Td2xAjO0JMxk1
        0FbMxYIc4n2bKph7XXWC9u2EEWl2fx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-6hO2WSIAMWeD3kkaBT-oyg-1; Wed, 11 Dec 2019 06:55:46 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB47818543D1;
        Wed, 11 Dec 2019 11:55:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1D5A5C1B5;
        Wed, 11 Dec 2019 11:55:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id C366B18034E9;
        Wed, 11 Dec 2019 11:55:44 +0000 (UTC)
Date:   Wed, 11 Dec 2019 06:55:44 -0500 (EST)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Message-ID: <17522697.476689.1576065344710.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191210113737.4016-3-johan@kernel.org>
References: <20191210113737.4016-1-johan@kernel.org> <20191210113737.4016-3-johan@kernel.org>
Subject: Re: [PATCH 2/7] Input: aiptek: fix endpoint sanity check
MIME-Version: 1.0
X-Originating-IP: [10.40.205.203, 10.4.195.30]
Thread-Topic: Input: aiptek: fix endpoint sanity check
Thread-Index: yxnpiHiLIHXEq4+MmBp4wSYn+N3S+A==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 6hO2WSIAMWeD3kkaBT-oyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A fix for a bug indeed, thank you Johan.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Johan Hovold" <johan@kernel.org>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, "Johan Hovold"
> <johan@kernel.org>, "stable" <stable@vger.kernel.org>, "Vladis Dronov" <vdronov@redhat.com>
> Sent: Tuesday, December 10, 2019 12:37:32 PM
> Subject: [PATCH 2/7] Input: aiptek: fix endpoint sanity check
> 
> The driver was checking the number of endpoints of the first alternate
> setting instead of the current one, something which could lead to the
> driver binding to an invalid interface.
> 
> This in turn could cause the driver to misbehave or trigger a WARN() in
> usb_submit_urb() that kernels with panic_on_warn set would choke on.
> 
> Fixes: 8e20cf2bce12 ("Input: aiptek - fix crash on detecting device without
> endpoints")
> Cc: stable <stable@vger.kernel.org>     # 4.4
> Cc: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

