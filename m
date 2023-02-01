Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4872C686713
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 14:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjBANjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 08:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBANjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 08:39:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9457DC15B;
        Wed,  1 Feb 2023 05:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H072VOHrXp4GY4j1x/3/j1jBrZ9UMoe6XDuOCjrdYAo=; b=dwn4ue0TeGHPJC+IZxn4F3llxK
        ZKDsJwjCJ9gTjoQTOqnuxkC8lgmKkWfHSYXusn80D8r/RUHSGLIH3XkOFEAPYHjbEDrcLcWn/Gmxs
        Gsp1hKaW55Zw+9/mUfnKA9gQNlymXwflpntMISN5s4hsLV32e1AOfXo7R0km13bwVnPYWxsv+VQq7
        IGYbnxfPDBgatGEPyUuEY++0g+DINxU1GWPbyZr3rFOzlA6L1XLA18SuXbJIU8eR9tPsQJkwzZJck
        kzy0uBsD1tJ8wTcEazZngAbuRw+La+WCm0YOSUQJAJNQS8KqRIBKAnLQxn/yGGO1C0PwveVBUhk8g
        FHebF49g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNDKx-00C7Dg-3k; Wed, 01 Feb 2023 13:39:43 +0000
Date:   Wed, 1 Feb 2023 05:39:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 0/3] avoid plaintext rdma offset if encryption is required
Message-ID: <Y9prn4niNung9Zer@infradead.org>
References: <cover.1675252643.git.metze@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675252643.git.metze@samba.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 01:04:40PM +0100, Stefan Metzmacher wrote:
> I think it is a security problem to send confidential data in plaintext
> over the wire, so we should avoid doing that even if rdma is in use.

Yep.

> Modern Windows servers support signed and encrypted rdma offload,
> but we don't support this yet...

There is a series out on the list for encryption offload to mlx5
hardware, whch is one way to handle this.  If not you need to bounce
buffer.
