Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9541A3A6A79
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 17:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhFNPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 11:35:41 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33587 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhFNPfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 11:35:40 -0400
Received: by mail-pg1-f178.google.com with SMTP id e20so8976085pgg.0
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 08:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R+pPQfYM0fffh9cjmlnt9HFr67UUmTUGUU/ksxJg7tk=;
        b=W9RKslR5HCM95X0ufqGm7hjIHfFU7Yzej7alamLbz2gojqnWJRqJe9Xh4G8slFcl/J
         ioI9TnccXkr0QbIVvO3tB7jNWmllRxGDEX+Rd/WqZiXkxqeB+ROKmP2CfQ99OntOB7dh
         i4A1jh4yDIskftlbNiKAjlrq5anjTPbElj/CM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+pPQfYM0fffh9cjmlnt9HFr67UUmTUGUU/ksxJg7tk=;
        b=OW68jUZKgkMXqkQuxbnsh1IrMmaJWJpuuai95ey9fwNUr2XQGP6a2Pi69yKff9owly
         z8cexaQ+t82YWAbEOYWiq+xeBJyhEijqdLLhwbqFREfxP/krOIVgnhwGkZtK33G4B6HH
         CKsP9dWBE3iX6i0TLXOr0AdvnHgMBZnxNxqydxOwoI9G1XYBT5KCvqYEhErnVBixH4Xv
         ribUN9iJON3wDaTkUPKs/cWKQKpXteAkVkdTMUFUvmBc8ZWSFs+oGGdK7e4TFkOUC9oY
         /qxwFkkco8fBXT+u9CSR/YS80T1XfQ1So4U6inTLF0S0Gw16tdownfcxcIbuq0EcuxkM
         xbXg==
X-Gm-Message-State: AOAM531VnjhvfGwowrdf4u+0QRQzzOiCuOZoOpb4QR+Yrzmo4z4T6RPD
        h6YzybkZdIC20x97CFJh3zidsg==
X-Google-Smtp-Source: ABdhPJwRKSTFDrtLbbhu7qg1vjwtmANL3p/lLYA+HjQfn45D25x/E/AMB0/789UHIXQJt/CH5fx2UA==
X-Received: by 2002:aa7:8588:0:b029:28e:dfa1:e31a with SMTP id w8-20020aa785880000b029028edfa1e31amr22108973pfn.77.1623684757307;
        Mon, 14 Jun 2021 08:32:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w25sm147164pgk.55.2021.06.14.08.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 08:32:36 -0700 (PDT)
Date:   Mon, 14 Jun 2021 08:32:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     youling257 <youling257@gmail.com>
Cc:     torvalds@linux-foundation.org, christian.brauner@ubuntu.com,
        andrea.righi@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-security-module@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Message-ID: <202106140826.7912F27CD@keescook>
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614100234.12077-1-youling257@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 06:02:34PM +0800, youling257 wrote:
> I used mainline kernel on android, this patch cause "failed to retrieve pid context" problem.
> 
> 06-14 02:15:51.165  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1682) failed to retrieve pid context.
> 06-14 02:15:51.166  1685  1685 E ServiceManager: add_service('batteryproperties',1) uid=0 - PERMISSION DENIED
> 06-14 02:15:51.166  1682  1682 I ServiceManager: addService() batteryproperties failed (err -1 - no service manager yet?).  Retrying...
> 06-14 02:15:51.197  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1695) failed to retrieve pid context.
> 06-14 02:15:51.197  1685  1685 E ServiceManager: add_service('android.security.keystore',1) uid=1017 - PERMISSION DENIED
> 06-14 02:15:51.198  1695  1695 I ServiceManager: addService() android.security.keystore failed (err -1 - no service manager yet?).  Retrying...
> 06-14 02:15:51.207  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1708) failed to retrieve pid context.
> 06-14 02:15:51.207  1685  1685 E ServiceManager: add_service('android.service.gatekeeper.IGateKeeperService',1) uid=1000 - PERMISSION DENIED
> 06-14 02:15:51.207  1708  1708 I ServiceManager: addService() android.service.gatekeeper.IGateKeeperService failed (err -1 - no service manager yet?).  Retrying...
> 06-14 02:15:51.275  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1693) failed to retrieve pid context.
> 06-14 02:15:51.275  1692  1692 I cameraserver: ServiceManager: 0xf6d309e0
> 06-14 02:15:51.275  1685  1685 E ServiceManager: add_service('drm.drmManager',1) uid=1019 - PERMISSION DENIED
> 06-14 02:15:51.276  1693  1693 I ServiceManager: addService() drm.drmManager failed (err -1 - no service manager yet?).  Retrying...
> 

Argh. Are you able to uncover what userspace is doing here?

So far, my test cases are:

1) self: open, write, close: allowed
2) self: open, clone thread. thread: change privileges, write, close: allowed
3) self: open, give to privileged process. privileged process: write: reject


-- 
Kees Cook
