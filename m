Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE172104CC9
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKUHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:45:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35500 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUHpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 02:45:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so1196890plp.2;
        Wed, 20 Nov 2019 23:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=K8z5lw0Y2x3HGxEqtUInasyPdyDDs0+pwtz6ApkXCy8=;
        b=FPgIpz88rq8puOuZAvR8yLx8Jhlk0WColC3s9M1CON3KQ/IiL5ssaY42gaI67Rw5mo
         VzSD22PRonUabSdzZPBVLADsknAvAzIp9kMocEMs9RIoYKKxhPV0is3x1L001Fs9rA2W
         1j9ip0vmJ9vZ4dP9WbkV7hTGTlCN+mNIt5Hw9CgG5+7ypM7mO0lfCXuuIJAACS6+O9ZP
         7OT6tp15PS9VIDBTow2cm+0u6N/dKKo+IqEg8Llwn5s2xlSy6tzpq6O0T32wb+LZVdaw
         pDjLSEH0BNXHU3GjfLpQ0h7n/gAFY6uP63XmReFOJV61xNZco20C2WyOhxMUJlnS6oMi
         c9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=K8z5lw0Y2x3HGxEqtUInasyPdyDDs0+pwtz6ApkXCy8=;
        b=AFPtlgixYtNPIF3L5l8kFuyOy7pwk9jjTlvc7Kr62KsotvXG+KBADByYih7cN8fU8A
         jO4FHl8AeHo32jxwWJZDIP7Se4J+Ms4bOobrnpTgs6lKH0CvZ/4RbZtVVERglw0KMy3O
         gGF0PAOOmDO1R6erVECCPgRCU+MjdrQ7YuBJf7tJaXUkjP4mkcoHTnhqIFJzT1CaYqCV
         Pcipf1xhaHS3V2NbR1Ti/kNajqJ+4y+2zpQOU3LPW/D7YoDXHWRM3bOyI51X6y3gzYjR
         XeosiCqPb+UUI/jO6iSxo3PS3Pqb8/CsRrv5QcX5dL6loio5smi8lIBU8/RmO/q9ize/
         kLtQ==
X-Gm-Message-State: APjAAAVSPqDmxH+A4MZac9XuYH/RSpugLPjfPlpL3k/Ld4p9GVqffFsK
        nAz3bZ27MEUkRkxOE+vQ3feqrsNI
X-Google-Smtp-Source: APXvYqz5WzIjxwY2qsMQLbCCU45Lo3pW7fLt28/eagPPe5zbTCyXAnLFMVVYCpcWz7Kwg0kl3etbYw==
X-Received: by 2002:a17:90a:a63:: with SMTP id o90mr9550397pjo.81.1574322332577;
        Wed, 20 Nov 2019 23:45:32 -0800 (PST)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id em16sm1660501pjb.21.2019.11.20.23.45.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 23:45:32 -0800 (PST)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id xAL7jBPU015447;
        Thu, 21 Nov 2019 15:45:11 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id xAL7jBaB015446;
        Thu, 21 Nov 2019 15:45:11 +0800
Date:   Thu, 21 Nov 2019 15:45:11 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, daniel@iogearbox.net, itugrok@yahoo.com,
        bpf@vger.kernel.org
Subject: [PATCH] bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_X shift by
 0
Message-ID: <20191121074511.GC15326@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 68a8357ec15bdce55266e9fba8b8b3b8143fa7d2 upstream.

The fix only affects x32 bpf jit, and it is critical to use x32 bpf jit on a
unpatched system, so I think we should backport it to the only affected stable
kernel version: v4.19

Thanks.

Cc: <stable@vger.kernel.org> #4.19

Signed-off-by: Wang YanQing <udknight@gmail.com>
