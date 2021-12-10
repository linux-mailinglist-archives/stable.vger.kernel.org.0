Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5C94703F7
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbhLJPj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:39:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242917AbhLJPj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 10:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639150582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aTsC5UMVQWvN3qZDNb1K4yW3e9uc3Gei8VL9gu3TJeU=;
        b=B4LvTpxlWeSPJsdM0xW+R3+K7flNF1bD9qAJgywTLt/2RhoBGs9xhqBvgRQWFYgoLTsF2d
        iVqUzt+KIx6R4ZsLNP2LGmBr8f85hP3+acvvNGAWtlIx4Sm2NnelfhV7stn9g/TsM4WSxj
        KrEIgv4W0LkzUMoDRjFzBQT1mFPBx9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-TwqV_gJmORSLJhYIKuInmw-1; Fri, 10 Dec 2021 10:36:18 -0500
X-MC-Unique: TwqV_gJmORSLJhYIKuInmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE9961B18BCF;
        Fri, 10 Dec 2021 15:36:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 835C05D9D5;
        Fri, 10 Dec 2021 15:36:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <163913443334205@kroah.com>
References: <163913443334205@kroah.com>
To:     gregkh@linuxfoundation.org
Cc:     dhowells@redhat.com, jefflexu@linux.alibaba.com,
        jlayton@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] netfs: fix parameter of cleanup()" failed to apply to 5.15-stable tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <292329.1639150575.1@warthog.procyon.org.uk>
Date:   Fri, 10 Dec 2021 15:36:15 +0000
Message-ID: <292330.1639150575@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> wrote:

> -			ops->cleanup(netfs_priv, folio_file_mapping(folio));
> +			ops->cleanup(folio_file_mapping(folio), netfs_priv);

Is it page->mapping or page_mapping(page) instead of folio_file_mapping()?  If
so, you can switch that to the other side instead, e.g.:

-			ops->cleanup(netfs_priv, page_mapping(page));
+			ops->cleanup(page_mapping(page), netfs_priv);

David

