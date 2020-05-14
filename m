Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162601D3089
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 15:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 09:01:14 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:47709 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgENNBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 09:01:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589461272; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: To:
 Subject: Sender; bh=KCrkZDljahm2VY1bQ73k/xbKgbU2wAdGuhnKSxUTF30=; b=Yyb3wKJL4hL+Fk7ACCAz9sTUmyeTFzb9QEJ1K750hosYWSOzatw7A4/G5N2qYInSLp966fp6
 vhchNNqRtaAnxC4l8WHBywZ4AM9iSyrjAsua1Ed6G3vPVfL6PBXKr58vPW+l7/LYHlN5ITlh
 lf13XPBjaPrP94tEoJD0/8l6uxM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebd40e7.7f006a2d4378-smtp-out-n02;
 Thu, 14 May 2020 13:00:23 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 49CEBC433BA; Thu, 14 May 2020 13:00:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.0.102] (unknown [183.83.139.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACE35C433D2;
        Thu, 14 May 2020 13:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ACE35C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
Subject: Re: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
To:     Sumit Semwal <sumit.semwal@linaro.org>, Greg KH <greg@kroah.com>,
        Chenbo Feng <fengc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        vinmenon@codeaurora.org, Greg Hackmann <ghackmann@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
References: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
 <20200512085221.GB3557007@kroah.com>
 <a3cbf675-becc-1713-bcdc-664ddfe4a544@codeaurora.org>
 <20200513125112.GC1083139@kroah.com>
 <20200513154653.GK206103@phenom.ffwll.local>
 <CAO_48GF0GMDJH1Wx4p5pfS4t57bh_BJO2=CmOpj_XCBnF0CbCQ@mail.gmail.com>
From:   Charan Teja Kalla <charante@codeaurora.org>
Message-ID: <20a2e97d-6a28-8bbd-044b-9d49aad0f65e@codeaurora.org>
Date:   Thu, 14 May 2020 18:30:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAO_48GF0GMDJH1Wx4p5pfS4t57bh_BJO2=CmOpj_XCBnF0CbCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you for the reply.

On 5/13/2020 9:33 PM, Sumit Semwal wrote:
> On Wed, 13 May 2020 at 21:16, Daniel Vetter <daniel@ffwll.ch> wrote:
>>
>> On Wed, May 13, 2020 at 02:51:12PM +0200, Greg KH wrote:
>>> On Wed, May 13, 2020 at 05:40:26PM +0530, Charan Teja Kalla wrote:
>>>>
>>>> Thank you Greg for the comments.
>>>> On 5/12/2020 2:22 PM, Greg KH wrote:
>>>>> On Fri, May 08, 2020 at 12:11:03PM +0530, Charan Teja Reddy wrote:
>>>>>> The following race occurs while accessing the dmabuf object exported as
>>>>>> file:
>>>>>> P1                               P2
>>>>>> dma_buf_release()          dmabuffs_dname()
>>>>>>                     [say lsof reading /proc/<P1 pid>/fd/<num>]
>>>>>>
>>>>>>                     read dmabuf stored in dentry->d_fsdata
>>>>>> Free the dmabuf object
>>>>>>                     Start accessing the dmabuf structure
>>>>>>
>>>>>> In the above description, the dmabuf object freed in P1 is being
>>>>>> accessed from P2 which is resulting into the use-after-free. Below is
>>>>>> the dump stack reported.
>>>>>>
>>>>>> We are reading the dmabuf object stored in the dentry->d_fsdata but
>>>>>> there is no binding between the dentry and the dmabuf which means that
>>>>>> the dmabuf can be freed while it is being read from ->d_fsdata and
>>>>>> inuse. Reviews on the patch V1 says that protecting the dmabuf inuse
>>>>>> with an extra refcount is not a viable solution as the exported dmabuf
>>>>>> is already under file's refcount and keeping the multiple refcounts on
>>>>>> the same object coordinated is not possible.
>>>>>>
>>>>>> As we are reading the dmabuf in ->d_fsdata just to get the user passed
>>>>>> name, we can directly store the name in d_fsdata thus can avoid the
>>>>>> reading of dmabuf altogether.
>>>>>>
>>>>>> Call Trace:
>>>>>>  kasan_report+0x12/0x20
>>>>>>  __asan_report_load8_noabort+0x14/0x20
>>>>>>  dmabuffs_dname+0x4f4/0x560
>>>>>>  tomoyo_realpath_from_path+0x165/0x660
>>>>>>  tomoyo_get_realpath
>>>>>>  tomoyo_check_open_permission+0x2a3/0x3e0
>>>>>>  tomoyo_file_open
>>>>>>  tomoyo_file_open+0xa9/0xd0
>>>>>>  security_file_open+0x71/0x300
>>>>>>  do_dentry_open+0x37a/0x1380
>>>>>>  vfs_open+0xa0/0xd0
>>>>>>  path_openat+0x12ee/0x3490
>>>>>>  do_filp_open+0x192/0x260
>>>>>>  do_sys_openat2+0x5eb/0x7e0
>>>>>>  do_sys_open+0xf2/0x180
>>>>>>
>>>>>> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
>>>>>> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
>>>>>> Cc: <stable@vger.kernel.org> [5.3+]
>>>>>> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
>>>>>> ---
>>>>>>
>>>>>> Changes in v2:
>>>>>>
>>>>>> - Pass the user passed name in ->d_fsdata instead of dmabuf
>>>>>> - Improve the commit message
>>>>>>
>>>>>> Changes in v1: (https://patchwork.kernel.org/patch/11514063/)
>>>>>>
>>>>>>  drivers/dma-buf/dma-buf.c | 17 ++++++++++-------
>>>>>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>>>>> index 01ce125..0071f7d 100644
>>>>>> --- a/drivers/dma-buf/dma-buf.c
>>>>>> +++ b/drivers/dma-buf/dma-buf.c
>>>>>> @@ -25,6 +25,7 @@
>>>>>>  #include <linux/mm.h>
>>>>>>  #include <linux/mount.h>
>>>>>>  #include <linux/pseudo_fs.h>
>>>>>> +#include <linux/dcache.h>
>>>>>>
>>>>>>  #include <uapi/linux/dma-buf.h>
>>>>>>  #include <uapi/linux/magic.h>
>>>>>> @@ -40,15 +41,13 @@ struct dma_buf_list {
>>>>>>
>>>>>>  static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>>>>>>  {
>>>>>> -        struct dma_buf *dmabuf;
>>>>>>          char name[DMA_BUF_NAME_LEN];
>>>>>>          size_t ret = 0;
>>>>>>
>>>>>> -        dmabuf = dentry->d_fsdata;
>>>>>> -        dma_resv_lock(dmabuf->resv, NULL);
>>>>>> -        if (dmabuf->name)
>>>>>> -                ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
>>>>>> -        dma_resv_unlock(dmabuf->resv);
>>>>>> +        spin_lock(&dentry->d_lock);
>>>>>
>>>>> Are you sure this lock always protects d_fsdata?
>>>>
>>>> I think yes. In the dma-buf.c, I have to make sure that d_fsdata should
>>>> always be under d_lock thus it will be protected. (In this posted patch
>>>> there is one place(in dma_buf_set_name) that is missed, will update this
>>>> in V3).
>>>>
>>>>>
>>>>>> +        if (dentry->d_fsdata)
>>>>>> +                ret = strlcpy(name, dentry->d_fsdata, DMA_BUF_NAME_LEN);
>>>>>> +        spin_unlock(&dentry->d_lock);
>>>>>>
>>>>>>          return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
>>>>>>                               dentry->d_name.name, ret > 0 ? name : "");
>>>>>
>>>>> If the above check fails the name will be what?  How could d_name.name
>>>>> be valid but d_fsdata not be valid?
>>>>
>>>> In case of check fails, empty string "" is appended to the name by the
>>>> code, ret > 0 ? name : "", ret is initialized to zero. Thus the name
>>>> string will be like "/dmabuf:".
>>>
>>> So multiple objects can have the same "name" if this happens to multiple
>>> ones at once?

Yes that it can happen.

>>>
>>>> Regarding the validity of d_fsdata, we are setting the dmabuf's
>>>> dentry->d_fsdata to NULL in the dma_buf_release() thus can go invalid if
>>>> that dmabuf is in the free path.
>>>
>>> Why are we allowing the name to be set if the dmabuf is on the free path
>>> at all?  Shouldn't that be the real fix here?

I don't think that user setting the name is the problem but accessing
the ->name while dmabuf is on the free path. And given a dmabuf we don't
know If that is already in the free path.

>>>
>>>>>> @@ -80,12 +79,16 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
>>>>>>  static int dma_buf_release(struct inode *inode, struct file *file)
>>>>>>  {
>>>>>>          struct dma_buf *dmabuf;
>>>>>> +        struct dentry *dentry = file->f_path.dentry;
>>>>>>
>>>>>>          if (!is_dma_buf_file(file))
>>>>>>                  return -EINVAL;
>>>>>>
>>>>>>          dmabuf = file->private_data;
>>>>>>
>>>>>> +        spin_lock(&dentry->d_lock);
>>>>>> +        dentry->d_fsdata = NULL;
>>>>>> +        spin_unlock(&dentry->d_lock);
>>>>>>          BUG_ON(dmabuf->vmapping_counter);
>>>>>>
>>>>>>          /*
>>>>>> @@ -343,6 +346,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>>>>>>          }
>>>>>>          kfree(dmabuf->name);
>>>>>>          dmabuf->name = name;
>>>>>> +        dmabuf->file->f_path.dentry->d_fsdata = name;
>>>>>
>>>>> You are just changing the use of d_fsdata from being a pointer to the
>>>>> dmabuf to being a pointer to the name string?  What's to keep that name
>>>>> string around and not have the same reference counting issues that the
>>>>> dmabuf structure itself has?  Who frees that string memory?
>>>>>
>>>>
>>>> Yes, I am just storing the name string in the d_fsdata in place of
>>>> dmabuf and this helps to get rid of any extra refcount requirement.
>>>> Because the user passed name carried in the d_fsdata is copied to the
>>>> local buffer in dmabuffs_dname under spin_lock(d_lock) and the same
>>>> d_fsdata is set to NULL(under the d_lock only) when that dmabuf is in
>>>> the release path. So, when d_fsdata is NULL, name string is not accessed
>>>> from the dmabuffs_dname thus extra count is not required.
>>>>
>>>> String memory, stored in the dmabuf->name, is released from the
>>>> dma_buf_release(). Flow will be like, It fist sets d_fsdata=NULL and
>>>> then free the dmabuf->name.
>>>>
>>>> However from your comments I have realized that there is a race in this
>>>> patch when using the name string between dma_buf_set_name() and
>>>> dmabuffs_dname(). But, If the idea of passing the name string inplace of
>>>> dmabuf in d_fsdata looks fine, I can update this next patch.
>>>
>>> I'll leave that to the dmabuf authors/maintainers, but it feels odd to
>>> me...
>>
>> I have zero clue about fs internals. This all scares me, that's all. I
>> know enough about lifetime bugs that if you don't deeply understand a
>> subsystem, all that's guaranteed is that you will get it wrong.
> 
> Likewise, and that made me realise that the 'fix' may not be as
> innocuous or quick.
> 
> I will try to check with some folks more experienced than me in the fs
> domain and see what is the logical way to handle it.
> 

BTW, I also would like to bring your notice that we have seen
sleep-while-atomic bug in the dmabuffs_dname() because of the mutex
used. It is caused from the SELinux permissions checks. I think SELinux
tries to validate the inherited files from fork + exec and in doing so,
it has to traverse the files. So, it relies on iterate_fd() (which
traverse files under spin_lock) and call
match_file(security/selinux/hooks.c) where the permission checks happen
and then dumps the information logs using dump_common_audit_data(). This
function is what actually trying to get the file path name and thus use
d_path(). If the file check happen on the dmabuf's fd, then it ends up
in ->dmabuffs_dname() under spin_lock(). So, flow will be like:
flush_unauthorized_files()
  iterate_fd()
    spin_lock()
      match_file()
        file_has_perm()
          avc_has_perm()
            avc_audit()
              slow_avc_audit()
	        common_lsm_audit()
		  dump_common_audit_data()
		    audit_log_d_path()
		      d_path()
                        dmabuffs_dname()
                          mutex_lock()--> Sleep while atomic.

So, we have to remove the use of mutex in the dmabuffs_dname(which is
another bug in the existing code).

Call trace captured is as below:
___might_sleep+0x204/0x208
__might_sleep+0x50/0x88
__mutex_lock_common+0x5c/0x1068
__mutex_lock_common+0x5c/0x1068
mutex_lock_nested+0x40/0x50
dmabuffs_dname+0xa0/0x170
d_path+0x84/0x290
audit_log_d_path+0x74/0x130
common_lsm_audit+0x334/0x6e8
slow_avc_audit+0xb8/0xf8
avc_has_perm+0x154/0x218
file_has_perm+0x70/0x180
match_file+0x60/0x78
iterate_fd+0x128/0x168
selinux_bprm_committing_creds+0x178/0x248
security_bprm_committing_creds+0x30/0x48
install_exec_creds+0x1c/0x68
load_elf_binary+0x3a4/0x14e0
search_binary_handler+0xb0/0x1e0

>>
>> /me out
>>
>> Cheers, Daniel
>>
> 
> Best,
> Sumit.
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project
